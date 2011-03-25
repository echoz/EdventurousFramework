//
//  JOURLRequestHelper.m
//  JONetwork
//
//  Created by Jeremy Foo on 2/11/11.
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

#import "JOURLRequest.h"
#import <CommonCrypto/CommonDigest.h>

#define HTTP_MULTIPART_BOUNDARY @"ihsdfo843290098fdji-08342-0fdipoa-0-0435"

@implementation JOURLRequest
@synthesize response = __response, request = __request, data = __data;
@synthesize delegate = __delegate, completionBlock, postProcessBlock, cancelBlock, authChallengeblock, authProtectSpaceBlock;
@synthesize completionReturn, hasCompletionReturn, useCredentialStorage;
@synthesize status = __status, autoResume;
@synthesize timeout;

-(id) init {
	if ((self = [super init])) {
		__data = [[NSMutableData data] retain];
		__connection = nil;
		
		hasCompletionReturn = NO;
		__status = JOURLRequestStatusNew;
		
		wasStarted = NO;
		useCredentialStorage = NO;
		
		timeout = 60.0;
		#if TARGET_OS_IPHONE
				
				requestRechability = [[Reachability reachabilityForInternetConnection] retain];
				
				//UIApplicationDidEnterBackgroundNotification
				[[NSNotificationCenter defaultCenter] addObserver:self
														 selector:@selector(didEnterBackground:) 
															 name:UIApplicationDidEnterBackgroundNotification
														   object:nil];
				
				//UIApplicationDidBecomeActiveNotification
				[[NSNotificationCenter defaultCenter] addObserver:self
														 selector:@selector(didBecomeActive:)
															 name:UIApplicationDidBecomeActiveNotification
														   object:nil];
				
				[[NSNotificationCenter defaultCenter] addObserver:self
														 selector:@selector(reachabilityChanged:)
															 name:kReachabilityChangedNotification 
														   object:nil];
				
				[requestRechability startNotifier];		
		#endif
		
	}
	return self;
}

-(id)initWithRequest:(NSURLRequest *)request startImmediately:(BOOL)startImmediately {
	if ((self = [self initWithRequest:request startImmediately:startImmediately delegate:nil])) {
		return self;
	}
	return nil;
}

-(id)initWithRequest:(NSURLRequest *)request startImmediately:(BOOL)startImmediately delegate:(id<JOURLRequestDelegate>)delegate {

	if ((self = [self init])) {
		__request = [request retain];
		self.delegate = delegate;
		
		if (startImmediately) {
			if (![self start]) {
				[self release];
				return nil;
			}
		}
	}
	
	return self;

}

-(id)initWithRequest:(NSURLRequest *)request startImmediately:(BOOL)startImmediately completionBlock:(CompletionBlock)block {
	
	if ((self = [self init])) {
		__request = [request retain];
		self.completionBlock = block;
		
		if (startImmediately) {
			if (![self start]) {
				[self release];
				return nil;
			}
		}
		
	}
	
	return self;
}

-(void)dealloc {
	#if TARGET_OS_IPHONE
		
		[[NSNotificationCenter defaultCenter] removeObserver:self];
		[requestRechability release], requestRechability = nil;
	#endif
	
	[completionBlock release];
	[postProcessBlock release];
	[cancelBlock release];
	
	[completionReturn release];
	
	[__response release], __response = nil;
	[__request release], __request = nil;
	[__data release], __data = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Network events
#if TARGET_OS_IPHONE

-(void)didBecomeActive:(NSNotification *)notification {
	
	JOURLRequestStatus previousStatus = self.status;
	
	if (self.status == JOURLRequestStatusMultitaskingInterrupted) {
		if ((autoResume) && (wasStarted)) {
			[self resume];
		}
	}
	
	if ([self.delegate respondsToSelector:@selector(request:didChangeStateFrom:toState:)]) {
		if (self.status != previousStatus) {
			[self.delegate request:self didChangeStateFrom:previousStatus toState:self.status];
			
		}
	}
	
}

-(void)didEnterBackground:(NSNotification *)notification {
	
	JOURLRequestStatus previousStatus = self.status;
	
	if (self.status == JOURLRequestStatusInProgress) {
		__status = JOURLRequestStatusMultitaskingInterrupted;
		[__connection cancel];

		if ([self.delegate respondsToSelector:@selector(request:didFailWithError:)]) {
			NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:JOURLRequestStatusMultitaskingInterrupted userInfo:nil];
			
			[self.delegate request:self didFailWithError:error];
		}
	
	}
	
	if ([self.delegate respondsToSelector:@selector(request:didChangeStateFrom:toState:)]) {
		if (self.status != previousStatus) {
			[self.delegate request:self didChangeStateFrom:previousStatus toState:self.status];
			
		}
	}

}

- (void) reachabilityChanged:(NSNotification *)notification {

	JOURLRequestStatus previousStatus = self.status;
	
	if (requestRechability) {
		Reachability *curReach = [notification object];
		
		if ([curReach currentReachabilityStatus] == NotReachable) {
			
			if (self.status == JOURLRequestStatusInProgress) {
				[__connection cancel];
				
				if ([self.delegate respondsToSelector:@selector(request:didFailWithError:)]) {
					NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:JOURLRequestStatusReachabilityIssue userInfo:nil];
					
					[self.delegate request:self didFailWithError:error];
				}

			}
			
			__status = JOURLRequestStatusReachabilityIssue;
			
		} else if (([curReach currentReachabilityStatus] == ReachableViaWiFi) || ([curReach currentReachabilityStatus] == ReachableViaWWAN)) {
			
			// auto resume
			if (self.status == JOURLRequestStatusReachabilityIssue) {
				[self resume];
			}
		}
	}
	
	if ([self.delegate respondsToSelector:@selector(request:didChangeStateFrom:toState:)]) {
		if (self.status != previousStatus) {
			[self.delegate request:self didChangeStateFrom:previousStatus toState:self.status];
			
		}
	}
	
}

#endif

#pragma mark -
#pragma mark NSURLRequest prep

// doesn't setup other parameters other than request

+(NSMutableURLRequest *)prepareRequestUsing:(NSDictionary *)postValues {
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	
	BOOL hasNSData = NO;
	for (NSString *key in postValues) {
		if ([[postValues objectForKey:key] isKindOfClass:[NSData class]]) {
			hasNSData = YES;
			break;
		}
	}
	
	if (hasNSData) {
		// multipart/formdata
		
		
		NSMutableData *postData = [NSMutableData data];
		for (NSString *key in postValues) {
			[postData appendData:[[NSString stringWithFormat:@"--%@\r\n", HTTP_MULTIPART_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
			
			if ([[postValues objectForKey:key] isKindOfClass:[NSData class]]) {
				
				// calculate MD5 of nsdata for filename
				unsigned char result[CC_MD5_DIGEST_LENGTH];
				CC_MD5([postValues objectForKey:key], [[postValues objectForKey:key] length], result);
				
				NSMutableString *hash = [NSMutableString string];
				
				for (int i = 0; i < 16; i++)
					[hash appendFormat:@"%02X", result[i]];
				
				
				[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, hash] dataUsingEncoding:NSUTF8StringEncoding]];
				[postData appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
				[postData appendData:[[NSString stringWithFormat:@"Content-Transfer-Encoding: base64\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
				
				[postData appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
				[postData appendData:[NSData dataWithData:[postValues objectForKey:key]]];
				[postData appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
			} else {
				// write content disposition
				[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
				
				// write value
				[postData appendData:[[NSString stringWithFormat:@"\r\n%@\r\n",[postValues objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
			}
		}
		
		if (postValues) {
			[postData appendData:[[NSString stringWithFormat:@"--%@--\r\n", HTTP_MULTIPART_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
			
			[request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", HTTP_MULTIPART_BOUNDARY] forHTTPHeaderField:@"Content-Type"];
			
			NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
			[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
			[request setHTTPBody:postData];
			
			[request setHTTPMethod:@"POST"];
			
		}
	} else {
		// x-www-form-urlencoded method
		
		// generate post string for posting
		NSMutableString *post = [NSMutableString string];	
		for (NSString *key in postValues) {
			if ([post length] > 0) {
				[post appendString:@"&"];
			}
			[post appendFormat:@"%@=%@",[self escapeString:key],[self escapeString:[postValues objectForKey:key]]];
		}
		
		if (postValues) {
			// add post data
			NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
			NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
			[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
			[request setHTTPBody:postData];
			
			[request setHTTPMethod:@"POST"];
			[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		}
	}
	
	return [request autorelease];
	
}

+(NSString *)escapeString:(NSString *)str withEscapees:(NSString *)escapees {
	return [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, (CFStringRef)escapees, kCFStringEncodingUTF8) autorelease];
}

+(NSString *)escapeString:(NSString *) str {
	return [self escapeString:str withEscapees:@" ()<>#%{}|\\^~[]`;/?:@=&$"];
}

#pragma mark -
#pragma mark String utility functions

+(NSString *)deNullify:(NSString *)str {
	if (str == (id)[NSNull null]) {
		return nil;
	} else {
		return str;
	}
}

+(NSString *)prepareEncodingForString:(NSString *)str {
	if (str) {
		return str;
	} else {
		return [NSString string];
	}
}

+(NSString *)stringFromArray:(NSArray *)array outterIndex:(NSUInteger)outterIndex innerIndex:(NSUInteger)innerIndex {
	if ([array count] >= outterIndex+1) {
		if ([[array objectAtIndex:outterIndex] count] >= innerIndex+1) {
			return [[array objectAtIndex:outterIndex] objectAtIndex:innerIndex];
		}
	}
	return nil;
}

+(NSArray *)stringsFromArray:(NSArray *)array forKey:(NSString *)key {
	
	NSMutableArray *stuff = [NSMutableArray arrayWithCapacity:0];
	
	for (NSArray *arr in array) {
		if ([[arr objectAtIndex:1] isEqualToString:key]) {
			[stuff addObjectsFromArray:[[arr objectAtIndex:2] componentsSeparatedByString:@", "]];
		}
	}
	
	return stuff;
}

#pragma mark -
#pragma mark Request Helper methods

-(BOOL)start {
	BOOL status = NO;
	
	
	if ((__status != JOURLRequestStatusInProgress) || (__status != JOURLRequestStatusReachabilityIssue)) {

		wasStarted = YES;
		
		[__request setTimeoutInterval:self.timeout];
		__connection = [[NSURLConnection connectionWithRequest:__request delegate:self] retain];
		
		if (__connection) {
			__status = JOURLRequestStatusInProgress;
			[__connection start];
			status = YES;
		} else {
			__status = JOURLRequestStatusFailed;
			status = NO;
		}
		
	}
	
	return status;
}

-(void)resume {
	if (((__status == JOURLRequestStatusMultitaskingInterrupted) || (__status == JOURLRequestStatusReachabilityIssue)) && (wasStarted)) {
		
		// temp set to cancel status which it kinda is because start won't 
		// accept reachability issues as a starting flag
		__status = JOURLRequestStatusCancel;
		[self start];
	}
}

-(void)cancel {
	__status = JOURLRequestStatusCancel;
	[__connection cancel];
	wasStarted = NO;
	
	if (self.cancelBlock) {
		self.cancelBlock(__data, __response, completionReturn);
	}
}

-(NSData *)synchronousRequest {
	NSHTTPURLResponse *response;
	NSError *error;
	
	return [self synchronousRequestWithResponse:&response error:&error];
}

-(NSData *)synchronousRequestWithResponse:(NSHTTPURLResponse **)response error:(NSError **)error {
	return [NSURLConnection sendSynchronousRequest:self.request returningResponse:response error:error];
}

-(id)synchronousRequestWithProcessing {
	NSHTTPURLResponse *response;
	NSError *error;
	
	NSData *final = [self synchronousRequestWithResponse:&response error:&error];
	
	return postProcessBlock(final,response);
}

-(void)synchronousRequestWithCompletion {
	NSHTTPURLResponse *response;
	NSError *error;
	
	NSData *final = [self synchronousRequestWithResponse:&response error:&error];
	
	id postprocessed = postProcessBlock(final,response);
	
	self.completionBlock(final,response,postprocessed);
}


#pragma mark -
#pragma mark NSURLConnection Delegate Methods


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[__data appendData:data];
	
	if ([self.delegate respondsToSelector:@selector(request:didRecieveData:)]) {
		[self.delegate request:self didRecieveData:data];
	}
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	__response = [response retain];
	[__data setLength:0];
	
	if ([self.delegate respondsToSelector:@selector(request:didRecieveResponse:)]) {
		[self.delegate request:self didRecieveResponse:response];
	}
}

-(void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {

	if ([self.delegate respondsToSelector:@selector(request:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:)]) {
		[self.delegate request:self didSendBodyData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
	}
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	__status = JOURLRequestStatusFailed;
	
	if ([self.delegate respondsToSelector:@selector(request:didFailWithError:)]) {
		[self.delegate request:self didFailWithError:error];
	}
	
}

-(BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
	return self.useCredentialStorage;
}

-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	BOOL how = NO;
	
	if (self.authProtectSpaceBlock) {
		how = self.authProtectSpaceBlock(connection, protectionSpace);
	}
	
	if ([self.delegate respondsToSelector:@selector(request:canAuthAgainstProtectionSpace:)]) {
		how = [self.delegate request:self canAuthAgainstProtectionSpace:protectionSpace];
	}
	
	return how;
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	if (self.authChallengeblock) {
		self.authChallengeblock(connection, challenge);		
	}
	
	if ([self.delegate respondsToSelector:@selector(request:didReceiveAuthChallenge:)]) {
		[self.delegate request:self didReceiveAuthChallenge:challenge];
	}
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
	if (self.postProcessBlock) {
		completionReturn = self.postProcessBlock(__data, __response);
		[completionReturn retain];
	}
	
	if (self.completionBlock) {
		self.completionBlock(__data, __response, completionReturn);		
	}
	
	__status = JOURLRequestStatusCompleted;

	if ([self.delegate respondsToSelector:@selector(didFinishRequest:)]) {
		[self.delegate didFinishRequest:self];
	}
	
}

@end
