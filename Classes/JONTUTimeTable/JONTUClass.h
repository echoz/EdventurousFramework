//
//  NTUClass.h
//  NTUAuth
//
//  Created by Jeremy Foo on 8/4/10.
//  Copyright 2010 ORNYX. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JONTUClass : NSObject <NSCoding> {
	NSString *type;
	NSString *group;
	NSString *__day;
	NSString *__time;
	NSString *venue;
	NSString *remark;
}

@property (readonly) NSString *type;
@property (readonly) NSString *group;
@property (readonly) NSString *venue;
@property (readonly) NSString *remark;

-(id)initWithType:(NSString *)classtype classGroup:(NSString *)classgroup venue:(NSString *)classvenue remark:(NSString *)classremark day:(NSString *)classday time:(NSString *)classtime;
-(NSDateComponents *) fromTime;
-(NSDateComponents *) toTime;
-(NSUInteger)dayIndex;
-(NSString *)fromTimeString;
-(NSString *)toTimeString;
-(NSArray *)activeWeeks;
@end
