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

#define HTTP_USER_AGENT @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_3; en-us) AppleWebKit/533.4+ (KHTML, like Gecko) Version/4.0.5 Safari/531.22.7"
#define AUTH_URL @"https://sso.wis.ntu.edu.sg/webexe88/owa/sso.asp"
#define TOKEN_URL @"https://sso.wis.ntu.edu.sg/webexe88/ntlm/sso_express.asp"
#define TOKEN_REGEX @"<input type=\"hidden\" name=\"p1\" value=\"(.*)\">\\s*<input type=\"hidden\" name=\"p2\" value=\"(.*)\">"
#define LEGAL_CHAR_TOESCAPE @" ()<>#%{}|\\^~[]`;/?:@=&$"

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
		auth = NO;
    }
    return self;
}

-(BOOL)auth {
	if (!auth) {
		return [self authWithRefresh:YES];
	} else {
		return auth;
	}
}

-(BOOL)canAuth {
	return ((user) && (pass) && (domain));
}

-(NSString *)escapeString:(NSString *) str {
	return [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR(" ()<>#%{}|\\^~[]`;/?:@=&$"), kCFStringEncodingUTF8) autorelease];
}

-(BOOL)authWithRefresh:(BOOL)refresh {
	// sso_express provides the real authentication variables on top of the cookies.
	// must grab p1 and p2.
	
	if (refresh) {
		auth = NO;
		
		NSMutableDictionary *postvalues = [NSMutableDictionary dictionaryWithCapacity:3];
		
		[postvalues setValue:[self escapeString:self.user] forKey:@"UserName"];
		[postvalues setValue:[self escapeString:self.pass] forKey:@"PIN"];
		[postvalues setValue:self.domain forKey:@"Domain"];
		
		NSString *test = [[NSString alloc] initWithData:[self sendSyncXHRToURL:[NSURL URLWithString:AUTH_URL] postValues:postvalues withToken:NO] encoding:NSUTF8StringEncoding];
		
		if ([test rangeOfString:@"may be invalid or has expired"].location == NSNotFound) {
			auth = YES;
			
			NSString *finalTokenURL = [TOKEN_URL stringByReplacingOccurrencesOfString:@"://" withString:[NSString stringWithFormat:@"://%@:%@@",[self escapeString:self.user],[self escapeString:self.pass]]];
			
			[test release], test = nil;
			
			// grab tokens!
			test = [[NSString alloc] initWithData:[self sendSyncXHRToURL:[NSURL URLWithString:finalTokenURL] postValues:nil withToken:NO] encoding:NSUTF8StringEncoding];
			studentid = [[test stringByMatching:TOKEN_REGEX capture:1] retain]; // p1
			secretToken = [[test stringByMatching:TOKEN_REGEX capture:2] retain]; // p2
			
		} else {
			auth = NO;
		}
		
		[test release];
	}
	return auth;
}

-(NSMutableURLRequest *)prepareURLRequestUsing:(NSDictionary *)postValues toURL:(NSURL *)url withToken:(BOOL)token {
	
	// setup URL Request
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:url];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	
	// add secret tokens if they are requested for and have been authed
	NSMutableDictionary *mutPostValues = [NSMutableDictionary dictionaryWithCapacity:2];
	if ((auth) && (token)) {
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
		[post appendFormat:@"%@=%@",key,[mutPostValues objectForKey:key]];
	}
		
	// add other http attributes based upon tokens or not
	if ((token) || (postValues != nil)) {
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
	NSArray *submitCookies = [NSArray arrayWithArray:self.cookies];
	if ((auth) && ([authCookies count] > 0)) {
		submitCookies = [submitCookies arrayByAddingObjectsFromArray:authCookies];
	}
	
	[request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:submitCookies]];

	return [request autorelease];
}

-(void)clearStaleCookies {
	
}


-(NSData *) sendSyncXHRToURL:(NSURL *)url postValues:(NSDictionary *)postValues withToken:(BOOL)token {
    
	if ([self canAuth]) {
		NSMutableURLRequest *request = [self prepareURLRequestUsing:postValues toURL:url withToken:token];
		//	[request setTimeoutInterval:60.0];
		NSHTTPURLResponse *response;
		
		NSData *recvData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
		
		NSArray *pastry = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[request URL]];
		
		// temporary array to store auth cookies
		NSMutableArray *specialCookies = [NSMutableArray arrayWithCapacity:2];
		
		for (NSHTTPCookie *cookie in pastry) {
			if (!auth) {
				if ([cookie.domain hasSuffix:@".wis.ntu.edu.sg"]) {
					[specialCookies addObject:cookie];
				}
			} else {
				[cookies addObject:cookie];
			}
		}
		
		// has auth cookies! update internal cookie store for authentication tokens
		if ([specialCookies count] > 0) {
			[authCookies release];
			authCookies = [specialCookies retain];
		}
		
		return recvData;
		
	} else {
		return nil;
	}
	
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
