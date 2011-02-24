//
//  JOURLRequestHelper.m
//  lbciphone
//
//  Created by Jeremy Foo on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JOURLRequest.h"


@implementation JOURLRequest
@synthesize response = __response, request = __request, data = __data;
@synthesize delegate = __delegate, completionBlock, postProcessBlock, cancelBlock;
@synthesize completionReturn, hasCompletionReturn;
@synthesize status = __status, autoResume;
@synthesize timeout;

-(id) init {
	if ((self = [super init])) {
		__data = [[NSMutableData data] retain];
		__connection = nil;
		
		hasCompletionReturn = NO;
		__status = JOURLRequestStatusNew;
		
		wasStarted = NO;
		
		timeout = 60.0;
		#ifdef TARGET_OS_IPHONE
				
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
	#ifdef TARGET_OS_IPHONE
		
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
#ifdef TARGET_OS_IPHONE

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
