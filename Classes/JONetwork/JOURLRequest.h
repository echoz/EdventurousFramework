//
//  JOURLRequest.h
//  lbciphone
//
//  Created by Jeremy Foo on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
	#import "Reachability.h"
	#import <UIKit/UIKit.h>
#endif

typedef id (^ProcessingBlock)(id, id);
typedef void (^CompletionBlock)(id,id,id);

@class JOURLRequest;

typedef enum {
	JOURLRequestStatusNew = 0,
	JOURLRequestStatusInProgress = 1,
	JOURLRequestStatusCompleted = 2,
	JOURLRequestStatusFailed = 3,
	JOURLRequestStatusReachabilityIssue = 4,
	JOURLRequestStatusMultitaskingInterrupted = 5,
	JOURLRequestStatusCancel = 6
} JOURLRequestStatus;

@protocol JOURLRequestDelegate <NSObject>
@optional
-(void)request:(JOURLRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;
-(void)didFinishRequest:(JOURLRequest *)request;
-(void)request:(JOURLRequest *)request didChangeStateFrom:(JOURLRequestStatus)previousState toState:(JOURLRequestStatus)currentState;
-(void)request:(JOURLRequest *)request didFailWithError:(NSError *)error;
-(void)request:(JOURLRequest *)request didRecieveResponse:(NSURLResponse *)response;
-(void)request:(JOURLRequest *)request didRecieveData:(NSData *)data;
@end

@interface JOURLRequest : NSObject {
	NSURLConnection *__connection;
	NSTimeInterval timeout;
	
    NSMutableURLRequest *__request;
	NSHTTPURLResponse *__response;
	NSMutableData *__data;
	id<JOURLRequestDelegate> __delegate;
	
	id completionReturn;
	BOOL hasCompletionReturn;
	
	JOURLRequestStatus __status;
	
	BOOL autoResume;
	BOOL wasStarted;
	
	CompletionBlock completionBlock;
	ProcessingBlock postProcessBlock;
	CompletionBlock cancelBlock;
	
	#if TARGET_OS_IPHONE
		Reachability *requestRechability;
	#endif
	
}

@property (nonatomic, readwrite) NSTimeInterval timeout;

@property (nonatomic, copy) CompletionBlock completionBlock;
@property (nonatomic, copy) ProcessingBlock postProcessBlock;
@property (nonatomic, copy) CompletionBlock cancelBlock;
@property (nonatomic, assign) id<JOURLRequestDelegate> delegate;

@property (readonly) NSMutableURLRequest *request;
@property (readonly) NSHTTPURLResponse *response;
@property (readonly) NSData *data;

@property (readonly) id completionReturn;
@property (readwrite) BOOL hasCompletionReturn;

@property (readonly) JOURLRequestStatus status;

@property (nonatomic, readwrite) BOOL autoResume;

-(id)initWithRequest:(NSURLRequest *)request startImmediately:(BOOL)startImmediately;
-(id)initWithRequest:(NSURLRequest *)request startImmediately:(BOOL)startImmediately delegate:(id<JOURLRequestDelegate>)delegate;
-(id)initWithRequest:(NSURLRequest *)request startImmediately:(BOOL)startImmediately completionBlock:(CompletionBlock) block;

-(BOOL)start;
-(void)resume;
-(void)cancel;

-(NSData *)synchronousRequest;
-(NSData *)synchronousRequestWithResponse:(NSHTTPURLResponse **)response error:(NSError **)error;

@end

