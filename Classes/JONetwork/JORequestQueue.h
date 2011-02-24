//
//  JORequestQueue.h
//  lbciphone
//
//  Created by Jeremy Foo on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
