//
//  JONTUSemesterDates.m
//  JONTUTimeTable
//
//  Created by Jeremy Foo on 9/1/10.
//  Copyright 2010 ORNYX. All rights reserved.
//

#import "JONTUSemesterDates.h"
#import "NSString+htmlentitiesaddition.h"
#import "RegexKitLite.h"

#define YEAR_URL @"http://www.ntu.edu.sg/Services/Academic/undergraduates/Academic%20Calendar/Pages/(year).aspx"
#define REGEX_TABLE_ROW @"<tr\\b[^>]*>(.*?)</tr>"
#define REGEX_TABLE_CELL @"<td\\b[^>]*>(.*?)</td>"
#define REGEX_STRIP_HTMLTAGS @"<(.|\\n)*?>"
#define REGEX_DATE @"([0-9]+)[-| ]+([a-zA-Z]+)[-| ]+([0-9]+)"

@implementation JONTUSemesterDates
@synthesize year, semesters;

-(id)initWithYear:(NSUInteger)yr {
	if (self = [super init]) {
		year = yr;
		semesters = nil;
	}
	return self;
}

-(NSString *)matchedPrefixString:(NSString *)needle inArray:(NSArray *)haystack {
	for (NSString *toMatch in haystack) {
		if ([needle hasPrefix:toMatch])
			return toMatch;
	}
	return nil;
}

-(NSInteger)indexMatchedPrefixString:(NSString *)needle inArray:(NSArray *)haystack {
	for (int i=0;i<[haystack count];i++) {
		if ([[haystack objectAtIndex:i] hasPrefix:needle]) {
			return i;
		}
	}
	return -1;
}

-(NSDictionary *)semesterWithCode:(NSString *)code {
	if ([code isEqualToString:@"1"]) {
		return [semesters objectForKey:@"SEMESTER 1"];
	} else if ([code isEqualToString:@"2"]) {
		return [semesters objectForKey:@"SEMESTER 2"];
	} else if ([code isEqualToString:@"S"]) {
		return [semesters objectForKey:@"SPECIAL TERM I"];
	} else if ([code isEqualToString:@"T"]) {
		return [semesters objectForKey:@"SPECIAL TERM II"];
	} else {
		return nil;
	}
}

-(NSDate *)dateFromDateString:(NSString *)dateStr {
	NSArray *months = [NSArray arrayWithObjects:@"JANUARY",@"FEBUARY",@"MARCH",@"APRIL",@"MAY",@"JUNE",@"JULY",@"AUGUST",@"SEPTEMBER",@"OCTOBER",@"NOVEMBER",@"DECEMBER",nil];
	NSArray *dateComps = [dateStr captureComponentsMatchedByRegex:REGEX_DATE];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *datecmp = [[NSDateComponents alloc] init];
			
	[datecmp setDay:[[dateComps objectAtIndex:1] intValue]];
	[datecmp setMonth:[self indexMatchedPrefixString:[[dateComps objectAtIndex:2] uppercaseString] inArray:months]+1];
	
	NSString *finalDate = [dateComps objectAtIndex:3];
	
	if ([finalDate length] == 2) {
		finalDate = [NSString stringWithFormat:@"20%@", finalDate];
	}
	
	[datecmp setYear:[finalDate intValue]];
	
	NSDate *parseDate = [gregorian dateFromComponents:datecmp];
	[datecmp release];
	[gregorian release];	

	return parseDate;
	
}

-(void)parse {
	
	NSMutableDictionary *sems = [NSMutableDictionary dictionary];
	NSArray *semesterNames = [NSArray arrayWithObjects:@"SEMESTER 1", @"SEMESTER 2", @"SPECIAL TERM II", @"SPECIAL TERM I", nil];
	
	NSString *toYearString = [NSString stringWithFormat:@"%i", year+1];
	NSString *page = [[NSString alloc] initWithData:[self sendSyncXHRToURL:[NSURL URLWithString:[YEAR_URL stringByReplacingOccurrencesOfString:@"(year)" withString:[NSString stringWithFormat:@"%i-%@", year, [toYearString stringByMatching:@"([0-9][0-9])$" capture:1]]]] 
																postValues:nil 
																 withToken:NO] 
										   encoding:NSUTF8StringEncoding];
	
	page = [[page removeHTMLEntities] stringByReplacingOccurrencesOfRegex:@"[\\n|\\t|\\r]" withString:@""];
	
	NSArray *rows = [page componentsMatchedByRegex:REGEX_TABLE_ROW];
	
	[page release];
	
	NSMutableDictionary *currentSemester = nil;
	NSString *currentSemesterName = nil;
	NSArray *rowcontents;
	NSString *testSemName;
	NSString *title;
	
	for (int i=0;i<[rows count];i++) {
		
		rowcontents = [[rows objectAtIndex:i] componentsMatchedByRegex:REGEX_TABLE_CELL];
		testSemName = [self matchedPrefixString:[[[rowcontents objectAtIndex:0] stringByReplacingOccurrencesOfRegex:REGEX_STRIP_HTMLTAGS withString:@""] uppercaseString]
											inArray:semesterNames];
		
		if ([[[[rowcontents objectAtIndex:0] stringByReplacingOccurrencesOfRegex:REGEX_STRIP_HTMLTAGS withString:@""] uppercaseString] hasPrefix:@"EVENTS"]) {
			[sems setObject:currentSemester forKey:currentSemesterName];
			i = [rows count];
			
		} else {
			// inspect for semester and setup
			if (testSemName) {
				if ((currentSemester) && (currentSemesterName)) {
					[sems setObject:currentSemester forKey:currentSemesterName];
				}				
				
				[currentSemesterName release], currentSemesterName = nil;
				currentSemesterName = testSemName;
				
				[currentSemester release], currentSemester = nil;
				currentSemester = [[NSMutableDictionary dictionary] retain];
				[currentSemester setObject:[self dateFromDateString:[[rowcontents objectAtIndex:1] stringByReplacingOccurrencesOfRegex:REGEX_STRIP_HTMLTAGS withString:@""]] forKey:@"SEM_START"];
				[currentSemester setObject:[self dateFromDateString:[[rowcontents objectAtIndex:2] stringByReplacingOccurrencesOfRegex:REGEX_STRIP_HTMLTAGS withString:@""]] forKey:@"SEM_END"];
				[currentSemester setObject:[[rowcontents objectAtIndex:3] stringByReplacingOccurrencesOfRegex:REGEX_STRIP_HTMLTAGS withString:@""] forKey:@"SEM_DURATION"];
				
				NSLog(@"Found %@", testSemName);
				
				rowcontents = [[rows objectAtIndex:++i] componentsMatchedByRegex:REGEX_TABLE_CELL];
				
			} 
			
			if ((currentSemester) && ([rowcontents count] == 4)) {
				// we already have a semster so we must parse data
				title = [[[rowcontents objectAtIndex:0] stringByReplacingOccurrencesOfRegex:REGEX_STRIP_HTMLTAGS withString:@""] uppercaseString];
				if ([title rangeOfString:@" "].location != NSNotFound) {
					title = [title substringToIndex:[title rangeOfString:@" "].location];					
				}
				
				[currentSemester setObject:[self dateFromDateString:[[rowcontents objectAtIndex:1] stringByReplacingOccurrencesOfRegex:REGEX_STRIP_HTMLTAGS withString:@""]] 
									forKey:[NSString stringWithFormat:@"%@_START", title]];
				[currentSemester setObject:[self dateFromDateString:[[rowcontents objectAtIndex:2] stringByReplacingOccurrencesOfRegex:REGEX_STRIP_HTMLTAGS withString:@""]]
									forKey:[NSString stringWithFormat:@"%@_END", title]];
				[currentSemester setObject:[[rowcontents objectAtIndex:3] stringByReplacingOccurrencesOfRegex:REGEX_STRIP_HTMLTAGS withString:@""]
									forKey:[NSString stringWithFormat:@"%@_DURATION", title]];
				
				NSLog(@"Found %@", [[rowcontents objectAtIndex:0] stringByReplacingOccurrencesOfRegex:REGEX_STRIP_HTMLTAGS withString:@""]);
			}
		}

	}
			
	
	[semesters release], semesters = nil;
	semesters = [sems retain];
	
}

-(void)dealloc {
	[semesters release], semesters = nil;
	[super dealloc];
}

@end
