//
//  JONTUAuth.m
//  JONTUAuth
//
//  Created by Jeremy Foo on 3/24/10.
//
//  The MIT License
//  
//  Copyright (c) 2010 Jeremy Foo
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "JONTUAuth.h"
#import "RegexKitLite.h"
#import "NSDataAdditions.h"

#define HTTP_USER_AGENT @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_3; en-us) AppleWebKit/533.4+ (KHTML, like Gecko) Version/4.0.5 Safari/531.22.7"
#define AUTH_URL @"https://sso.wis.ntu.edu.sg/webexe88/owa/sso.asp"
#define TOKEN_URL @"https://sso.wis.ntu.edu.sg/webexe88/ntlm/sso_express.asp"
#define TOKEN_REGEX @"<input type=\"hidden\" name=\"p1\" value=\"(.*)\">\\s*<input type=\"hidden\" name=\"p2\" value=\"(.*)\">"
#define LEGAL_CHAR_TOESCAPE @" ()<>#%{}|\\^~[]`;/?:@=&$"

#define EDVENTURE_LOGIN_CHECK @"<input value=\"/ntu_post_login.html\" name=\"new_loc\" type=\"hidden\">"

@implementation JONTUAuth

@synthesize cookies, user, pass, domain, studentid, authCookies;

-(id)init {
    if (self = [super init]) {
        cookies = [[NSMutableArray alloc] initWithCapacity:0];
		authCookies = nil;
		studentid = nil;
		secretToken = nil;
		user = nil;
		pass = nil;
		domain = nil;
		wisAuth = NO;
		edventureAuth = NO;
		authing = NO;
    }
    return self;
}

-(NSString *)escapeString:(NSString *) str {
	return [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR(" ()<>#%{}|\\^~[]`;/?:@=&$"), kCFStringEncodingUTF8) autorelease];
}

-(BOOL)wisAuth {
	
	// sso_express provides the real authentication variables on top of the cookies.
	// must grab p1 and p2.

	BOOL auth = NO;
	
	NSMutableDictionary *postvalues = [NSMutableDictionary dictionaryWithCapacity:3];
	[postvalues setValue:self.user forKey:@"UserName"];
	[postvalues setValue:self.pass forKey:@"PIN"];
	[postvalues setValue:self.domain forKey:@"Domain"];
	
	NSString *test = [[NSString alloc] initWithData:[self sendSyncXHRToURL:[NSURL URLWithString:AUTH_URL] postValues:postvalues withToken:NO] encoding:NSUTF8StringEncoding];
	
	if ([test rangeOfString:@"may be invalid or has expired"].location == NSNotFound) {
		
		NSString *finalTokenURL = [TOKEN_URL stringByReplacingOccurrencesOfString:@"://" withString:[NSString stringWithFormat:@"://%@:%@@",[self escapeString:self.user],[self escapeString:self.pass]]];
		
		[test release], test = nil;
		
		// grab tokens!
		test = [[NSString alloc] initWithData:[self sendSyncXHRToURL:[NSURL URLWithString:finalTokenURL] postValues:nil withToken:NO] encoding:NSUTF8StringEncoding];
		studentid = [[test stringByMatching:TOKEN_REGEX capture:1] retain]; // p1
		secretToken = [[test stringByMatching:TOKEN_REGEX capture:2] retain]; // p2
		
		auth = YES;
	} else {
		auth = NO;
	}
	
	[test release];

	return auth;
}

-(BOOL)edventureAuth {
	BOOL auth = NO;
	
	[self sendSyncXHRToURL:[NSURL URLWithString:@"https://edventure.ntu.edu.sg/webapps/login?action=logout"] postValues:nil withToken:NO];
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
	[dict setObject:@"login" forKey:@"action"];
	[dict setObject:@"" forKey:@"remote-user"];
	[dict setObject:@"/webapps/portal/frameset.jsp" forKey:@"new_loc"];
	[dict setObject:@"" forKey:@"auth_type"];
	[dict setObject:@"" forKey:@"one_time_token"];
	[dict setObject:[[self.pass dataUsingEncoding:NSASCIIStringEncoding] base64Encoding] forKey:@"encoded_pw"];
	[dict setObject:[[self.pass dataUsingEncoding:NSUTF16LittleEndianStringEncoding] base64Encoding] forKey:@"encoded_pw_unicode"];
	[dict setObject:self.user forKey:@"user_id"];
	[dict setObject:@"" forKey:@"password"];
	
	NSData *test = [self sendSyncXHRToURL:[NSURL URLWithString:@"https://edventure.ntu.edu.sg/webapps/login/"]
							   postValues:dict 
								withToken:NO];
	
	NSString *testString = [[NSString alloc] initWithData:test encoding:NSUTF8StringEncoding];
	
	if ([[testString lowercaseString] rangeOfString:EDVENTURE_LOGIN_CHECK].location == NSNotFound) {
		auth = YES;
	} else {
		auth = NO;
	}
	
	[testString release];
	
	return auth;
}


-(BOOL)canAuth {
	return ((user) && (pass) && (domain));
}


-(BOOL)auth {
	return (wisAuth) && (edventureAuth);
}

-(BOOL)singleSignOn {
	
	[authCookies release], authCookies = nil;
	
	authing = YES;
	wisAuth = [self wisAuth];
	edventureAuth = [self edventureAuth];
	authing = NO;
	
	[cookies removeAllObjects];
	
	return [self auth];
}

-(NSMutableURLRequest *)prepareURLRequestUsing:(NSDictionary *)postValues toURL:(NSURL *)url withToken:(BOOL)token {
	
	// setup URL Request
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:url];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	
	// add secret tokens if they are requested for and have been authed
	NSMutableDictionary *mutPostValues = [NSMutableDictionary dictionaryWithCapacity:2];
	if (([self auth]) && (token)) {
		[mutPostValues setObject:studentid forKey:@"P1"];
		[mutPostValues setObject:secretToken forKey:@"P2"];
	}
	
	// add postvalues if they exist
	if (postValues) {
		[mutPostValues addEntriesFromDictionary:postValues];
	}

	// generate post string for posting
	NSMutableString *post = [NSMutableString string];	
	for (NSString *key in mutPostValues) {
		if ([post length] > 0) {
			[post appendString:@"&"];
		}
		[post appendFormat:@"%@=%@",[self escapeString:key],[self escapeString:[mutPostValues objectForKey:key]]];
	}
	
	// add other http attributes based upon tokens or not
	if ((token) || (postValues)) {
		// add post data
		NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
		NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
		[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
		[request setHTTPBody:postData];
		
		[request setHTTPMethod:@"POST"];
		[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	}
	
	[request setValue:HTTP_USER_AGENT forHTTPHeaderField:@"User-Agent"];
	
	// assemble cookies!
	NSMutableArray *submitCookies = [NSMutableArray arrayWithArray:self.cookies];
	for (NSHTTPCookie *cookie in authCookies) {
		if ([url.host hasSuffix:cookie.domain]) {
			[submitCookies addObject:cookie];
		}
	}
	
	[request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:submitCookies]];

	return [request autorelease];
}
-(NSData *) sendSyncXHRToURL:(NSURL *)url postValues:(NSDictionary *)postValues withToken:(BOOL)token {
	
	return [self sendSyncXHRToURL:url postValues:postValues withToken:token returningResponse:nil error:nil];
}

-(NSData *) sendSyncXHRToURL:(NSURL *)url postValues:(NSDictionary *)postValues withToken:(BOOL)token returningResponse:(NSHTTPURLResponse **) response error:(NSError **)error {
    
	if ([self canAuth]) {
		NSMutableURLRequest *request = [self prepareURLRequestUsing:postValues toURL:url withToken:token];
		//	[request setTimeoutInterval:60.0];
		
		if (!response) {
			NSHTTPURLResponse **response;			
		}
		
		NSData *recvData = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
		
		NSArray *pastry = [NSHTTPCookie cookiesWithResponseHeaderFields:[*response allHeaderFields] forURL:[request URL]];
		
		// temporary array to store auth cookies
		NSMutableArray *specialCookies = [NSMutableArray arrayWithCapacity:2];
				
		for (NSHTTPCookie *cookie in pastry) {
			if (authing) {
				if ([cookie.domain isEqualToString:@".wis.ntu.edu.sg"] || [cookie.domain isEqualToString:@"edventure.ntu.edu.sg"]) {
					[specialCookies addObject:cookie];
				}
			} else {
				[cookies addObject:cookie];
			}
		}
		
		// has auth cookies! update internal cookie store for authentication tokens
		if (authing) {
			if ([specialCookies count] > 0) {
				
				NSMutableArray *tempcookies = [NSMutableArray arrayWithCapacity:3];
				[tempcookies addObjectsFromArray:authCookies];
				[tempcookies addObjectsFromArray:specialCookies];
				
								
				[authCookies release];
				authCookies = [tempcookies retain];
			}			
		}
		
		return recvData;
		
	} else {
		return nil;
	}
	
}

-(void)clearStaleCookies {
	NSMutableArray *staleCookies = [NSMutableArray arrayWithCapacity:0];
	for (NSHTTPCookie *cookie in cookies) {
		if ([cookie.expiresDate timeIntervalSinceNow] < 0) {
			[staleCookies addObject:cookie];
		}
	}
	
	[cookies removeObjectsInArray:staleCookies];
}

/* 
 
 this for a later implementation if we really need a run loop based way of getting url
 
-(BOOL) sendAsyncXHRToURL:(NSURL *)url postValues:(NSDictionary *)postValues {

	NSMutableURLRequest *syncRequest = [self prepareURLRequestUsing:postValues toURL:url];
	NSURLConnection *syncConnection = [[NSURLConnection alloc] initWithRequest:syncRequest delegate:self];
	BOOL status = NO;	
		
	if (syncConnection) {
		NSLog(@"Sent Request: %@ using %@", syncRequest, syncConnection);
		status = YES;
		syncRecvData = [[NSMutableData alloc] init];
		
	} else {
		status = NO;
	}
	
	return status;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	// This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
	
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
	
    // receivedData is an instance variable declared elsewhere.
	
	NSArray *pastry = [NSHTTPCookie cookiesWithResponseHeaderFields:[((NSHTTPURLResponse *)response) allHeaderFields] forURL:response.URL];
    
    for (NSHTTPCookie *cookie in pastry) {
        if ([cookie.domain hasSuffix:@".wis.ntu.edu.sg"]) {
            [cookies addObject:cookie];
        }
    }
	
    [syncRecvData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [syncRecvData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %u bytes of data",[syncRecvData length]);
	NSLog(@"%@", [[[NSString alloc] initWithData:syncRecvData encoding:NSUTF8StringEncoding] autorelease]);
	
    // release the connection, and the data object
    [connection release];
    [syncRecvData release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [syncRecvData release];
	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    NSURLRequest *newRequest = request;
    if (redirectResponse) {
        newRequest = nil;
    }
    return newRequest;
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	
    if ([challenge previousFailureCount] == 0) {
        NSURLCredential *newCredential;
        newCredential = [NSURLCredential credentialWithUser:self.user
												   password:self.pass
												persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:newCredential
               forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        // inform the user that the user name and password
        // in the preferences are incorrect
		NSLog(@"Can't auth");
    }
}
 */

-(void)dealloc {
	[authCookies release], authCookies = nil;
	[secretToken release], secretToken = nil;
	[cookies release], cookies = nil;
	[user release], user = nil;
	[pass release], pass = nil;
	[domain release], domain = nil;
	[studentid release], studentid = nil;
	[super dealloc];
}

@end
