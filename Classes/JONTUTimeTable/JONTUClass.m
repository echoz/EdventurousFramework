#import "JONTUClass.h"
#import "RegexKitLite.h"

#define REGEX_TIME_SUBUNIT @"([0-9]{2})([0-9]{2})-([0-9]{2})([0-9]{2})"
#define REGEX_TIME_STRING @"([0-9]{4})-([0-9]{4})"
#define REGEX_RECURRENCE_THROUGH @"Wk([0-9]+)-([0-9]+)"

@implementation JONTUClass

#pragma mark -
#pragma mark Object Lifecycle

-(void)didTurnIntoFault {
	[__activeWeeks release], __activeWeeks = nil;
	[super didTurnIntoFault];
}

+(JONTUClass *)classForCourse:(JONTUCourse *)course onDay:(NSString *)day spanningTime:(NSString *)time managedContext:(NSManagedObjectContext *)moc {
	NSSet *results = [moc fetchObjectsForEntityName:[JONTUClass entityName] withPredicate:@"(course == %@) AND (day == %@) AND (time == %@)", course, day, time];
	
	if ([results count] == 1) {
		return [results anyObject];
	} else {
		JONTUClass *class = [[JONTUClass alloc] initWithEntity:[NSEntityDescription entityForName:[JONTUClass entityName] inManagedObjectContext:moc]
								insertIntoManagedObjectContext:moc];
		
		class.course = course;
		class.day = day;
		class.time = time;
		
		return class;
	}
}

#pragma mark -
#pragma mark Instance methods

-(BOOL)array:(NSArray *)arr hasNumber:(NSNumber *)num {
	NSNumber *testnumber;
	
	for (id n in arr) {
		if ([n isKindOfClass:[NSString class]]) {
			testnumber = [NSNumber numberWithInt:[n intValue]];
		} else {
			testnumber = n;
		}					
		
		if ([testnumber isEqualToNumber:num]) {
			return YES;
		}			
		
	}
	return NO;
}

-(NSArray *)activeWeeks {
	if (!__activeWeeks) {
		NSArray *weeks = [self.remark captureComponentsMatchedByRegex:REGEX_RECURRENCE_THROUGH];
		
		if ([weeks count] == 0) {
			// seperated by commas or not
			weeks = [[self.remark stringByReplacingOccurrencesOfString:@"Wk" withString:@""] componentsSeparatedByString:@","];
		} else {
			
			// this is weeks from a number to another
			
			NSMutableArray *tempweeks = [NSMutableArray array];
			for (int i=[[weeks objectAtIndex:1] intValue];i<[[weeks objectAtIndex:2] intValue]+1;i++) {
				[tempweeks addObject:[NSString stringWithFormat:@"%d",i]];
			}
			weeks = tempweeks;
		}
		
		__activeWeeks = [weeks retain];
	}
	
	return __activeWeeks;
}

-(BOOL)isActiveForWeek:(NSUInteger)week {
	BOOL active = NO;
	
	if (week > 0) {
		NSString *weekStr = [NSString stringWithFormat:@"%d", week];
		
		for (NSString *wk in __activeWeeks) {
			if ([wk isEqualToString:weekStr]) {
				active = YES;
				break;
			}
		}
		
	}
	
	
	return active;
}

-(NSString *)fromTimeString {
	return [self.time stringByMatching:REGEX_TIME_STRING capture:1];
}

-(NSString *)toTimeString {
	return [self.time stringByMatching:REGEX_TIME_STRING capture:2];	
}

-(NSDateComponents *) fromTime {
	NSDateComponents *comp = [[NSDateComponents alloc] init];
	[comp setHour:[[self.time stringByMatching:REGEX_TIME_SUBUNIT capture:1] integerValue]];
	[comp setMinute:[[self.time stringByMatching:REGEX_TIME_SUBUNIT capture:2] integerValue]];
	
	[comp setWeekday:[self dayIndex]];
	
	return [comp autorelease];
}
-(NSDateComponents *) toTime {
	NSDateComponents *comp = [[NSDateComponents alloc] init];
	[comp setHour:[[self.time stringByMatching:REGEX_TIME_SUBUNIT capture:3] integerValue]];
	[comp setMinute:[[self.time stringByMatching:REGEX_TIME_SUBUNIT capture:4] integerValue]];
	
	[comp setWeekday:[self dayIndex]];
	
	return [comp autorelease];
}

-(NSUInteger)dayIndex {
	NSArray *weekdays = [NSArray arrayWithObjects:@"M",@"T",@"W",@"TH",@"F",nil];
	return [weekdays indexOfObject:self.day];
}


@end
