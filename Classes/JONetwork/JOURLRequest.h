//
//  JOURLRequest.h
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

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
	#import "Reachability.h"
	#import <UIKit/UIKit.h>
#endif

typedef id (^ProcessingBlock)(id, id);
typedef void (^CompletionBlock)(id,id,id);
typedef void (^AuthChallengeBlock)(id,id);
typedef BOOL (^AuthProtectSpaceBlock)(id,id);

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
-(void)request:(JOURLRequest *)request didReceiveAuthChallenge:(NSURLAuthenticationChallenge *)authChallenge;
-(BOOL)request:(JOURLRequest *)request canAuthAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;
-(void)request:(JOURLRequest *)request didCancelAuthChallenge:(NSURLAuthenticationChallenge *)authChallenge;
@end

@interface JOURLRequest : NSObject {
	NSURLConnection *__connection;
	NSTimeInterval timeout;
	NSURLAuthenticationChallenge *authChallenge;
	
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
	AuthChallengeBlock authChallengeBlock;
	AuthChallengeBlock authCancelChallengeBlock;
	AuthProtectSpaceBlock authProtectSpaceBlock;
	
	BOOL useCredentialStorage;
	
	#if TARGET_OS_IPHONE
		Reachability *requestRechability;
	#endif
	
}

@property (nonatomic, readwrite) NSTimeInterval timeout;

@property (nonatomic, copy) CompletionBlock completionBlock;
@property (nonatomic, copy) ProcessingBlock postProcessBlock;
@property (nonatomic, copy) CompletionBlock cancelBlock;
@property (nonatomic, copy) AuthChallengeBlock authChallengeblock; 
@property (nonatomic, copy) AuthChallengeBlock authCancelChallengeBlock;
@property (nonatomic, copy) AuthProtectSpaceBlock authProtectSpaceBlock;
@property (nonatomic, assign) id<JOURLRequestDelegate> delegate;

@property (readonly) NSMutableURLRequest *request;
@property (readonly) NSHTTPURLResponse *response;
@property (readonly) NSData *data;

@property (readonly) id completionReturn;
@property (readwrite) BOOL hasCompletionReturn;

@property (readonly) JOURLRequestStatus status;

@property (nonatomic, readwrite) BOOL autoResume;
@property (nonatomic, readwrite) BOOL useCredentialStorage;

-(id)initWithRequest:(NSURLRequest *)request startImmediately:(BOOL)startImmediately;
-(id)initWithRequest:(NSURLRequest *)request startImmediately:(BOOL)startImmediately delegate:(id<JOURLRequestDelegate>)delegate;
-(id)initWithRequest:(NSURLRequest *)request startImmediately:(BOOL)startImmediately completionBlock:(CompletionBlock) block;

-(BOOL)start;
-(void)resume;
-(void)cancel;

-(NSData *)synchronousRequest;
-(id)synchronousRequestWithProcessing;
-(void)synchronousRequestWithCompletion;
-(NSData *)synchronousRequestWithResponse:(NSHTTPURLResponse **)response error:(NSError **)error;

+(NSMutableURLRequest *)prepareRequestUsing:(NSDictionary *)postValues;
+(NSString *)deNullify:(NSString *)str;
+(NSString *)prepareEncodingForString:(NSString *)str;
+(NSString *)escapeString:(NSString *)str withEscapees:(NSString *)escapees;
+(NSString *)escapeString:(NSString *) str;
+(NSArray *)stringsFromArray:(NSArray *)array forKey:(NSString *)key;
+(NSString *)stringFromArray:(NSArray *)array outterIndex:(NSUInteger)outterIndex innerIndex:(NSUInteger)innerIndex;
@end

