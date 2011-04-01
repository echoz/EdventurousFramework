#import "_JONTUClass.h"

@interface JONTUClass : _JONTUClass {}


-(NSDateComponents *) fromTime;
-(NSDateComponents *) toTime;
-(NSUInteger)dayIndex;
-(NSString *)fromTimeString;
-(NSString *)toTimeString;
-(NSArray *)activeWeeks;
-(BOOL)isActiveForWeek:(NSUInteger)week;
@end
