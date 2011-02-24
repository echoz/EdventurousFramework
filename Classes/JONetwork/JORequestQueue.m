//
//  JORequestQueue.m
//  JONetwork
//
//  Created by Jeremy Foo on 2/8/11.
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
//

#import "JORequestQueue.h"

@implementation JORequestQueue

@synthesize concurrentConnections = __concurrentConnections;
@synthesize delegate = __delegate;


-(id)init {
	if ((self = [super init])) {		
		__queue = [[NSMutableArray arrayWithCapacity:0] retain];
		__delegates = [[NSMutableArray arrayWithCapacity:0] retain];
		__status = [[NSMutableArray arrayWithCapacity:0] retain];
		
		__concurrentConnections = 4;
	}
	return self;
}

-(void)dealloc {
	[__queue release], __queue = nil;
	[__delegates release], __delegates = nil;
	[__status release], __status = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Queue Events

-(void)processQueue {
	NSArray *active = [self active];
	
	if ([active count] < self.concurrentConnections) {
		NSArray *waiting = [self waiting];
		
		for (int i=0;i<[waiting count];i++) {
			if (i<(self.concurrentConnections - [active count])) {
				if ([self statusForRequest:[waiting objectAtIndex:i]] == JORequestQueueStatusActive) {
					[((JOURLRequest *)[waiting objectAtIndex:i]) start];
				}
			} else {
				break;
			}
		}
		
	}
}


#pragma mark -
#pragma mark Queue Management

-(void)enqueueRequest:(JOURLRequest *)request forDelegate:(id)delegate withQueueStatus:(JORequestQueueStatus)status {
	request.delegate = self;
	[__status addObject:[NSNumber numberWithInt:status]];
	
	if (delegate) {
		[__delegates addObject:delegate];
	} else {
		[__delegates addObject:[NSNull null]];
	}
	
	[__queue addObject:request];
	
	[self processQueue];
}

-(JOURLRequest *)nextRequest {
	NSArray *waiting = [self waiting];
	
	if ([waiting count] > 0) {
		return [waiting objectAtIndex:0];
	} else {
		return nil;
	}
}

-(JORequestQueueStatus)queueStatusFromNumber:(NSNumber *)number {
	
	int tempstatus = [number intValue];
	
	switch (tempstatus) {
		case JORequestQueueStatusActive:
			return JORequestQueueStatusActive;

		case JORequestQueueStatusPause:
			return JORequestQueueStatusPause;
			
		case JORequestQueueStatusError:
			return JORequestQueueStatusError;
			
		default:
			return JORequestQueueStatusPause;
	}
	
}

-(NSInteger)indexForRequest:(JOURLRequest *)request {
	for (int i=0;i<[__queue count];i++) {
		if ([__queue objectAtIndex:i] == request) {
			return i;
		}
	}
	return -1;
}


-(id<JORequestQueueDelegate>)delegateForRequest:(JOURLRequest *)request {
	
	NSInteger index = [self indexForRequest:request];
	
	if (index > -1) {
		return [__delegates objectAtIndex:index];
	} else {
		return nil;
	}
	
}

-(void)setDelegate:(id<JORequestQueueDelegate>)delegate forRequest:(JOURLRequest *)request {	
	[__delegates replaceObjectAtIndex:[self indexForRequest:request] withObject:delegate];
}

-(JORequestQueueStatus)statusForRequest:(JOURLRequest *)request {
	
	NSInteger index = [self indexForRequest:request];
	
	if (index > -1) {
		return [self queueStatusFromNumber:[__status objectAtIndex:index]];
	} else {
		return -1;
	}
}

-(void)setStatus:(JORequestQueueStatus)status forRequest:(JOURLRequest *)request {
	[__status replaceObjectAtIndex:[self indexForRequest:request] withObject:[NSNumber numberWithInt:status]];
	[self processQueue];
}

-(NSArray *)queue {
	return __queue;
}

-(NSArray *)active {
	NSMutableArray *activearr = [NSMutableArray arrayWithCapacity:0];
	
	for (JOURLRequest *request in __queue) {
		if (request.status == JOURLRequestStatusInProgress) {
			[activearr addObject:request];
		}
	}
	
	return activearr;
}

-(NSArray *)waiting {
	NSMutableArray *waiting = [__queue mutableCopy];
	
	[waiting removeObjectsInArray:[self active]];
	
	return [waiting autorelease];
}

#pragma mark -
#pragma mark JOURLRequest Delegate Methods

-(void)request:(JOURLRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
	if ([self.delegate respondsToSelector:@selector(request:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:)]) {
		[self.delegate request:request didSendBodyData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
	}
}
-(void)didFinishRequest:(JOURLRequest *)request {
	NSInteger index = [self indexForRequest:request];
	
	[__delegates removeObjectAtIndex:index];
	[__status removeObjectAtIndex:index];
	[__queue removeObject:request];
	
	[self processQueue];
	
	if ([self.delegate respondsToSelector:@selector(requestDidFinish:)]) {
		[self.delegate requestDidFinish:request];
	}
}
-(void)request:(JOURLRequest *)request didFailWithError:(NSError *)error {
	[self setStatus:JORequestQueueStatusError forRequest:request];
	[self processQueue];
	
	if ([self.delegate respondsToSelector:@selector(request:didFailWithError:)]) {
		[self.delegate request:request didFailWithError:error];
	}

}
-(void)request:(JOURLRequest *)request didRecieveResponse:(NSURLResponse *)response {
	if ([self.delegate respondsToSelector:@selector(request:didRecieveResponse:)]) {
		[self.delegate request:request didRecieveResponse:response];
	}

}
-(void)request:(JOURLRequest *)request didRecieveData:(NSData *)data {
	if ([self.delegate respondsToSelector:@selector(request:didRecieveData:)]) {
		[self.delegate request:request didRecieveData:data];
	}

}

@end
