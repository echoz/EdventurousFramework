//
//  JONTUCourse.m
//  JONTUTimeTable
//
//  Created by Jeremy Foo on 8/4/10.
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

#import "JONTUCourse.h"
#import "RegexKitLite.h"
#import "JONTUSemester.h"

#define QUERY_URL @"https://wish.wis.ntu.edu.sg/webexe/owa/AUS_SUBJ_CONT.main_display1"

// first 4 captures
#define REGEX_MOD_BASE @"<TD\\b[^>]*><B><FONT\\b[^>]*>(.*?)</FONT></B></TD>" 

// defined in key value pairs
#define REGEX_MOD_SPECIALREQ @"<TD><B><FONT\\b[^>]*>(.*?)</FONT></B></TD>\\n<TD COLSPAN=\"2\"><B><FONT\\b[^>]*>(.*?)</FONT></B></TD>"
#define REGEX_MOD_DESC @"<TD WIDTH=\"650\" colspan=\"4\"><FONT SIZE=2>\\n(.*)\\n*</TD>"

#define REGEX_MOD_TERMINATE @"###No Courses found###"

#define MOD_MATCH_PREREQ @"Prerequisite:"
#define MOD_MATCH_MUTEX @"Mutually exclusive with: "
#define MOD_MATCH_NOCORE @"Not available as Core to Programme: "
#define MOD_MATCH_NOUE @"Not available as UE to Programme: "
#define MOD_MATCH_NOPE @"Not available as PE to Programme: "

@implementation JONTUCourse

@synthesize name, au, type, su, gepre, index, status, choice, classes;
@synthesize title, runBy, prerequisite, notAvailPE, notAvailUE, notAvailCORE, details;
@synthesize semester;

-(id)initWithName:(NSString *)coursename academicUnits:(NSUInteger) acadunit courseType:(NSString *)coursetype suOption:(NSString *)suopt gePreType:(NSString *)gepretype
	  indexNumber:(NSString *)indexNumber registrationStatus:(NSString *)regstat choice:(NSUInteger) coursechoice pullAditionalInfo:(BOOL)additionalInfo {
	
	if (self = [super init]) {
		name = [coursename retain];
		au = acadunit;
		type = [coursetype retain];
		su = [suopt retain];
		gepre = [gepretype retain];
		index = [indexNumber retain];
		status = [regstat retain];
		choice = coursechoice;
		classes = [[NSArray array] retain];
		
		if (additionalInfo) {
			[self parse];
		}
	}
	
	return self;
}

-(id)initWithCourseCode:(NSString *)ccode year:(NSUInteger)year semester:(NSString *)sem {
	JONTUSemester *josem = [[JONTUSemester alloc] initWithName:@"" year:year semester:sem];
	
	if (self = [self initWithCourseCode:ccode Semester:josem]) {

	}
	
	[josem release];
	
	return self;
}

-(id)initWithCourseCode:(NSString *)ccode Semester:(JONTUSemester *)sem {
	if (self = [super init]) {
		name = [ccode retain];
		self.semester = sem;
	}
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super init]) {
		name = [[aDecoder decodeObjectForKey:@"name"] retain];
		au = [aDecoder decodeIntForKey:@"acadunit"];
		type = [[aDecoder decodeObjectForKey:@"type"] retain];
		su = [[aDecoder decodeObjectForKey:@"su"] retain];
		gepre = [[aDecoder decodeObjectForKey:@"gepre"] retain];
		index = [[aDecoder decodeObjectForKey:@"index"] retain];
		status = [[aDecoder decodeObjectForKey:@"status"] retain];
		choice = [aDecoder decodeIntForKey:@"choice"];
		classes = [[aDecoder decodeObjectForKey:@"classes"] retain];
		
		title = [[aDecoder decodeObjectForKey:@"title"] retain];
		runBy = [[aDecoder decodeObjectForKey:@"runBy"] retain];
		prerequisite = [[aDecoder decodeObjectForKey:@"prerequisite"] retain];
		notAvailPE = [[aDecoder decodeObjectForKey:@"notAvailPE"] retain];
		notAvailUE = [[aDecoder decodeObjectForKey:@"notAvailUE"] retain];
		notAvailCORE = [[aDecoder decodeObjectForKey:@"notAvailCORE"] retain];
		details = [[aDecoder decodeObjectForKey:@"details"] retain];
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:name forKey:@"name"];
	[aCoder encodeObject:type forKey:@"type"];
	[aCoder encodeObject:su forKey:@"su"];
	[aCoder encodeObject:gepre forKey:@"gepre"];
	[aCoder encodeObject:index forKey:@"index"];
	[aCoder encodeObject:status forKey:@"status"];
	[aCoder encodeObject:name forKey:@"name"];
	[aCoder encodeInt:au forKey:@"acadunit"];
	[aCoder encodeInt:choice forKey:@"choice"];
	
	[aCoder encodeObject:title forKey:@"title"];
	[aCoder encodeObject:runBy forKey:@"runBy"];
	[aCoder encodeObject:prerequisite forKey:@"prerequisite"];
	[aCoder encodeObject:notAvailPE forKey:@"notAvailPE"];
	[aCoder encodeObject:notAvailUE forKey:@"notAvailUE"];
	[aCoder encodeObject:notAvailCORE forKey:@"notAvailCORE"];	
	[aCoder encodeObject:details forKey:@"details"];

}

-(NSString *)stringFromArray:(NSArray *)array outterIndex:(NSUInteger)outterIndex innerIndex:(NSUInteger)innerIndex {
	if ([array count] >= outterIndex+1) {
		if ([[array objectAtIndex:outterIndex] count] >= innerIndex+1) {
			return [[array objectAtIndex:outterIndex] objectAtIndex:innerIndex];
		}
	}
	return nil;
}

-(NSArray *)stringsFromArray:(NSArray *)array forKey:(NSString *)key {
	
	NSMutableArray *stuff = [NSMutableArray arrayWithCapacity:0];
	
	for (NSArray *arr in array) {
		if ([[arr objectAtIndex:1] isEqualToString:key]) {
			[stuff addObjectsFromArray:[[arr objectAtIndex:2] componentsSeparatedByString:@", "]];
		}
	}
	
	return stuff;
}

-(BOOL)parse {
	BOOL parsestatus = NO;
	NSMutableDictionary *postValues = [NSMutableDictionary dictionary];
	[postValues setObject:[semester semester] forKey:@"semester"];
	[postValues setObject:[NSString stringWithFormat:@"%i",[semester year]] forKey:@"acad"];
	[postValues setObject:[NSString stringWithFormat:@"%i_%@",[semester year], [semester semester]] forKey:@"acadsem"];
	[postValues setObject:@"Search" forKey:@"boption"];
	[postValues setObject:self.name forKey:@"r_subj_code"];
	[postValues setObject:@"" forKey:@"r_course_yr"];
	
	NSData *courseInfoData = nil;
	
	if (semester) {
		courseInfoData = [semester sendSyncXHRToURL:[NSURL URLWithString:QUERY_URL] postValues:postValues withToken:NO];
	} else {
		courseInfoData = [self sendSyncXHRToURL:[NSURL URLWithString:QUERY_URL] postValues:postValues withToken:NO];
	}
	
	
	NSString *courseInfoStr = [[NSString alloc] initWithData:courseInfoData encoding:NSUTF8StringEncoding];
	
	if (![courseInfoStr isMatchedByRegex:REGEX_MOD_TERMINATE]) {
		NSArray *courseBase = [courseInfoStr arrayOfCaptureComponentsMatchedByRegex:REGEX_MOD_BASE];
		NSArray *courseSpecialReq = [courseInfoStr arrayOfCaptureComponentsMatchedByRegex:REGEX_MOD_SPECIALREQ];
		NSArray *courseDesc = [courseInfoStr arrayOfCaptureComponentsMatchedByRegex:REGEX_MOD_DESC];
		
		// deal with course base first
		title = [[self stringFromArray:courseBase outterIndex:1 innerIndex:1] retain];
		au = [[self stringFromArray:courseBase outterIndex:2 innerIndex:1] intValue];
		runBy = [[self stringFromArray:courseBase outterIndex:3 innerIndex:1] retain];
		
		// next special req shit
		prerequisite = [[self stringsFromArray:courseSpecialReq forKey:MOD_MATCH_PREREQ] retain];
		notAvailCORE = [[self stringsFromArray:courseSpecialReq forKey:MOD_MATCH_NOCORE] retain];
		notAvailUE = [[self stringsFromArray:courseSpecialReq forKey:MOD_MATCH_NOUE] retain];
		notAvailPE = [[self stringsFromArray:courseSpecialReq forKey:MOD_MATCH_NOPE] retain];
		
		// description
		details = [[self stringFromArray:courseDesc outterIndex:0 innerIndex:1] retain];
		
		parsestatus = YES;
	}
	
	[courseInfoStr release];
	
	return parsestatus;
}

-(NSString *)description {
	return [NSString stringWithFormat:@"<NTUCourse: %@ with %i classes>",self.name, [self.classes count]];
}

-(NSUInteger)classesCount {
	return [self.classes count];
}

-(void)dealloc {
	[name release], name = nil;
	[type release], type = nil;
	[su release], su = nil;
	[gepre release], gepre = nil;
	[index release], index = nil;
	[status release], status = nil;
	[classes release], classes = nil;
	
	[title release], title = nil;
	[runBy release], runBy = nil;
	[prerequisite release], prerequisite = nil;
	[notAvailPE release], notAvailPE = nil;
	[notAvailUE release], notAvailUE = nil;
	[notAvailCORE release], notAvailCORE = nil;
	[details release], details = nil;
	
	[semester release], semester = nil;
	
	[super dealloc];
}

@end
