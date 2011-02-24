//
//  JORequestQueue.h
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

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "JOURLRequest.h"

@class JORequestQueue;

typedef enum {
	JORequestQueueStatusActive = 0,
	JORequestQueueStatusPause = 1,
	JORequestQueueStatusError = 3
} JORequestQueueStatus;

@protocol JORequestQueueDelegate <NSObject>
@optional
-(void)requestDidFinish:(JOURLRequest *)request;
-(void)request:(JOURLRequest *)request didRecieveData:(NSData *)data;
-(void)request:(JOURLRequest *)request didFailWithError:(NSError *)error;
-(void)request:(JOURLRequest *)request didRecieveResponse:(NSURLResponse *)response;
-(void)request:(JOURLRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;

@end

@interface JORequestQueue : NSObject <JOURLRequestDelegate> {

    NSMutableArray *__queue;
	NSMutableArray *__delegates;
	NSMutableArray *__status;
	NSUInteger __concurrentConnections;
	
	id<JORequestQueueDelegate> __delegate;

}

@property (nonatomic, readwrite) NSUInteger concurrentConnections;

@property (nonatomic, assign) id<JORequestQueueDelegate> delegate;

-(id<JORequestQueueDelegate>)delegateForRequest:(JOURLRequest *)request;
-(JORequestQueueStatus)statusForRequest:(JOURLRequest *)request;
-(void)setDelegate:(id<JORequestQueueDelegate>)delegate forRequest:(JOURLRequest *)request;
-(void)setStatus:(JORequestQueueStatus)status forRequest:(JOURLRequest *)request;

-(NSInteger)indexForRequest:(JOURLRequest *)request;
-(void)enqueueRequest:(JOURLRequest *)request forDelegate:(id)delegate withQueueStatus:(JORequestQueueStatus)status;
-(JOURLRequest *)nextRequest;
-(JORequestQueueStatus)queueStatusFromNumber:(NSNumber *)number;

-(NSArray *)queue;
-(NSArray *)active;
-(NSArray *)waiting;

@end
