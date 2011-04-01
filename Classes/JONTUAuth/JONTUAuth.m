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

@synthesize cookies, user, pass, domain, studentid, credential;
@synthesize timeout;

SYNTHESIZE_SINGLETON_FOR_CLASS(JONTUAuth);

#pragma mark -
#pragma mark Object Lifecycle

-(id)init {
    if ((self = [super init])) {
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
		timeout = 60.0;
		credential = nil;
    }
    return self;
}


-(void)dealloc {
	[credential release], credential = nil;
	[authCookies release], authCookies = nil;
	[secretToken release], secretToken = nil;
	[cookies release], cookies = nil;
	[user release], user = nil;
	[pass release], pass = nil;
	[domain release], domain = nil;
	[studentid release], studentid = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Convinence Methods

-(NSString *)escapeString:(NSString *) str {
	return [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR(" ()<>#%{}|\\^~[]`;/?:@=&$"), kCFStringEncodingUTF8) autorelease];
}


-(BOOL)canAuth {
	return ((user) && (pass) && (domain));
}


-(BOOL)auth {
	return (wisAuth) && (edventureAuth);
}

#pragma mark -
#pragma mark Cookie Management

-(NSArray *)authCookies {
	return authCookies;
}

-(void)processURL:(NSURL *)url sessionCookiesForResponse:(NSHTTPURLResponse *)response {
	NSArray *sessioncookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:url];
	
	for (NSHTTPCookie *cookie in sessioncookies) {
		if (([authCookies indexOfObject:cookie] == NSNotFound) && ([cookies indexOfObject:cookie] == NSNotFound)) {
			[cookies addObject:sessioncookies];
		}
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

#pragma mark -
#pragma mark Sign on Requests

-(JOURLRequest *)tokenRequest {
	
	JOURLRequest *tokenrequest = nil;
	if (wisAuth) {
		// assume credentail has been created from competion block?
		tokenrequest = [[JOURLRequest alloc] initWithRequest:[JOURLRequest prepareRequestUsing:nil] startImmediately:NO];
		[tokenrequest.request setURL:[NSURL URLWithString:TOKEN_URL]];
		
		tokenrequest.postProcessBlock = ^(id _data, id _response) {
			NSString *test = [[NSString alloc] initWithData:(NSData *)_data encoding:NSUTF8StringEncoding];
			
			NSMutableDictionary *tokens = [NSMutableDictionary dictionaryWithCapacity:2];
			
			[tokens setObject:[test stringByMatching:TOKEN_REGEX capture:1] forKey:@"studentid"];
			[tokens setObject:[test stringByMatching:TOKEN_REGEX capture:2] forKey:@"secretToken"];
			
			[test release];
			
			tokenrequest.hasCompletionReturn = YES;
			
			return (id)tokens;
			
		};
		
	}
	
	return [tokenrequest autorelease];
}

-(JOURLRequest *)wisAuthRequest {
	
	// sso_express provides the real authentication variables on top of the cookies.
	// must grab p1 and p2.
	
	JOURLRequest *wisrequest = nil;
	
	if (![self auth]) {
		NSMutableDictionary *postvalues = [NSMutableDictionary dictionaryWithCapacity:3];
		[postvalues setValue:self.user forKey:@"UserName"];
		[postvalues setValue:self.pass forKey:@"PIN"];
		[postvalues setValue:self.domain forKey:@"Domain"];
		
		wisrequest = [[JOURLRequest alloc] initWithRequest:[JOURLRequest prepareRequestUsing:postvalues] startImmediately:NO];
		[wisrequest.request setURL:[NSURL URLWithString:AUTH_URL]];

		wisrequest.postProcessBlock = ^(id _data, id _response) {
			
			NSString *test = [[NSString alloc] initWithData:(NSData *)_data encoding:NSUTF8StringEncoding];
			NSMutableArray *theCookies = nil;
			
			if ([test rangeOfString:@"may be invalid or has expired"].location == NSNotFound) {
				NSArray *acookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[(NSHTTPURLResponse *)_response allHeaderFields] 
																			  forURL:[NSURL URLWithString:AUTH_URL]];
				
				theCookies = [NSMutableArray arrayWithCapacity:2];
				
				for (NSHTTPCookie *cookie in acookies) {
					if ([cookie.domain isEqualToString:@".wis.ntu.edu.sg"] || [cookie.domain isEqualToString:@"edventure.ntu.edu.sg"]) {
						[theCookies addObject:cookie];
					}
				}
				
				wisrequest.hasCompletionReturn = YES;
			} 
			
			[test release];
		
			return (id)theCookies;
		};
		
	}	

	return [wisrequest autorelease];
}

-(JOURLRequest *)edventureAuthRequest {
	
	JOURLRequest *edventurelogin = nil;

	if (![self auth]) {
		
		/* need to do logout first
		edventurelogin = [[JOURLRequest alloc] initWithRequest:[JOURLRequest prepareRequestUsing:nil] startImmediately:NO];
		[edventurelogin.request setURL:[NSURL URLWithString:@"https://edventure.ntu.edu.sg/webapps/login?action=logout"]];
		 */

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
		
		edventurelogin = [[JOURLRequest alloc] initWithRequest:[JOURLRequest prepareRequestUsing:dict] startImmediately:NO];
		[edventurelogin.request setURL:[NSURL URLWithString:@"https://edventure.ntu.edu.sg/webapps/login/"]];
		
		edventurelogin.postProcessBlock = ^(id _data, id _response) {
			NSString *test = [[NSString alloc] initWithData:(NSData *)_data encoding:NSUTF8StringEncoding];
			NSMutableArray *theCookies = nil;
			
			if ([[test lowercaseString] rangeOfString:EDVENTURE_LOGIN_CHECK].location == NSNotFound) {
				NSArray *acookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[(NSHTTPURLResponse *)_response allHeaderFields] 
																		   forURL:[NSURL URLWithString:AUTH_URL]];
				
				theCookies = [NSMutableArray arrayWithCapacity:2];
				
				for (NSHTTPCookie *cookie in acookies) {
					if ([cookie.domain isEqualToString:@".wis.ntu.edu.sg"] || [cookie.domain isEqualToString:@"edventure.ntu.edu.sg"]) {
						[theCookies addObject:cookie];
					}
				}
				
				edventurelogin.hasCompletionReturn = YES;

			} 
			
			[test release];
			
			return (id)theCookies;
		};		
	}

	return [edventurelogin autorelease];
}

#pragma mark -
#pragma mark Sign on Process

-(void)singleSignOn {
	
	[authCookies release], authCookies = nil;
	authCookies = [[NSMutableArray arrayWithCapacity:2] retain];
	
	JOURLRequest *wis = [self wisAuthRequest];
	JOURLRequest *tokens = [self tokenRequest];
	JOURLRequest *edventure = [self edventureAuthRequest];
	
	edventure.completionBlock = ^(id _data, id _response, id _completion) {
		if (edventure.hasCompletionReturn) {
			[authCookies addObjectsFromArray:(NSArray *)_completion];
		}
	};
	
	tokens.completionBlock = ^(id _data, id _response, id _compeletion) {
		if (tokens.hasCompletionReturn) {
			NSDictionary *dict = (NSDictionary *)_compeletion;
			
			studentid = [[dict objectForKey:@"studentid"] retain];
			secretToken = [[dict objectForKey:@"secretToken"] retain];
		}
	};
	
	tokens.useCredentialStorage = NO;
	
	tokens.authChallengeBlock = ^(id _connection, id _authChallenge) {
		
		NSURLAuthenticationChallenge *authChallenge = (NSURLAuthenticationChallenge *)_authChallenge;		
		[[authChallenge sender] useCredential:self.credential forAuthenticationChallenge:authChallenge];
		
	};
	
	wis.completionBlock = ^(id _data, id _response, id _completion) {
		if (wis.hasCompletionReturn) {
			[authCookies addObjectsFromArray:(NSArray *)_completion];
			credential = [NSURLCredential credentialWithUser:self.user password:self.pass persistence:NSURLCredentialPersistenceNone];
			
			[tokens start];
		}
	};
	
	[wis start];
	[edventure start];
}

#pragma mark -
#pragma mark NSURLRequest creation

-(NSURLRequest *)authedRequestForURL:(NSURL *)url withValues:(NSDictionary *)values usingTokens:(BOOL)tokens {
	
	NSMutableURLRequest *mutrequest = nil;
	
	// add auth cookies
	NSMutableArray *submitcookies = [NSMutableArray arrayWithCapacity:2];
	for (NSHTTPCookie *authcookie in authCookies) {
		if ([url.host hasSuffix:authcookie.domain]) {
			[submitcookies addObject:authcookie];				
		}
	}
	
	// add session cookies
	for (NSHTTPCookie *normalcookie in cookies) {
		if ([url.host hasSuffix:normalcookie.domain]) {
			[submitcookies addObject:normalcookie];
		}
	}

	
	if (values) {
		// post method
		// fill post values with tokens if requested
		NSMutableDictionary *dictvalues = [values mutableCopy];		
		if (tokens) {
			[dictvalues setObject:studentid forKey:@"P1"];
			[dictvalues setObject:secretToken forKey:@"P2"];
		}
		mutrequest = [JOURLRequest prepareRequestUsing:dictvalues];
		
		
	} else {
		// get method
		mutrequest = [JOURLRequest prepareRequestUsing:nil];
	}
	
	[mutrequest setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:submitcookies]];
	[mutrequest setURL:url];
	
	return mutrequest;
	
}

-(JOURLRequest *)authedJORequestForURL:(NSURL *)url withValues:(NSDictionary *)values usingTokens:(BOOL)tokens {
	JOURLRequest *request = [[JOURLRequest alloc] initWithRequest:[self authedRequestForURL:url withValues:values usingTokens:tokens]
												 startImmediately:NO];
	
	request.authProtectSpaceBlock = ^(id _connection, id _protectionspace) {
		NSURLProtectionSpace *protectionSpace = (NSURLProtectionSpace *)_protectionspace;
		
		if (([protectionSpace authenticationMethod] == NSURLAuthenticationMethodHTTPBasic) || ([protectionSpace authenticationMethod] == NSURLAuthenticationMethodHTTPDigest)) {
			return YES;
		}
		
		return NO;
		
	};
	
	request.authChallengeBlock = ^(id _connection, id _challenge) {
		NSURLAuthenticationChallenge *challenge = (NSURLAuthenticationChallenge *)_challenge;
		
		if ([challenge previousFailureCount] == 0) {
			[[challenge sender] useCredential:self.credential forAuthenticationChallenge:challenge];
		} else {
			[[challenge sender] cancelAuthenticationChallenge:challenge];
		}
		
	};
	
	return [request autorelease];
}

@end
