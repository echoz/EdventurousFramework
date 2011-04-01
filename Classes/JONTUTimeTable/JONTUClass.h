#import "_JONTUClass.h"
#import "JONTUCourse.h"

@interface JONTUClass : _JONTUClass {
	NSArray *__activeWeeks;
}
+(JONTUClass *)classForCourse:(JONTUCourse *)course onDay:(NSString *)day spanningTime:(NSString *)time managedContext:(NSManagedObjectContext *)moc;

-(NSDateComponents *) fromTime;
-(NSDateComponents *) toTime;
-(NSUInteger)dayIndex;
-(NSString *)fromTimeString;
-(NSString *)toTimeString;
-(NSArray *)activeWeeks;
-(BOOL)isActiveForWeek:(NSUInteger)week;
@end
