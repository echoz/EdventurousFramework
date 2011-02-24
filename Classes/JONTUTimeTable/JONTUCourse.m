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


+(JOURLRequest *)courseWithCode:(NSString *)code forYear:(NSUInteger)year semester:(NSString *)sem {
	NSMutableDictionary *postValues = [NSMutableDictionary dictionary];
	[postValues setObject:sem forKey:@"semester"];
	[postValues setObject:[NSString stringWithFormat:@"%i",year] forKey:@"acad"];
	[postValues setObject:[NSString stringWithFormat:@"%i_%@",year, sem] forKey:@"acadsem"];
	[postValues setObject:@"Search" forKey:@"boption"];
	[postValues setObject:code forKey:@"r_subj_code"];
	[postValues setObject:@"" forKey:@"r_course_yr"];
	
	NSMutableURLRequest *request = [JOURLRequest prepareRequestUsing:postValues];
	[request setURL:[NSURL URLWithString:QUERY_URL]];
	
	JOURLRequest *urlrequest = [[JOURLRequest alloc] initWithRequest:request startImmediately:NO];
	ProcessingBlock processblk = ^(id _data, id _response) {
		NSString *courseInfoStr = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
		id returning = nil;
		
		if (![courseInfoStr isMatchedByRegex:REGEX_MOD_TERMINATE]) {
			NSMutableDictionary *returnvalues = [NSMutableDictionary dictionaryWithCapacity:11];
						
			NSArray *courseBase = [courseInfoStr arrayOfCaptureComponentsMatchedByRegex:REGEX_MOD_BASE];
			NSArray *courseSpecialReq = [courseInfoStr arrayOfCaptureComponentsMatchedByRegex:REGEX_MOD_SPECIALREQ];
			NSArray *courseDesc = [courseInfoStr arrayOfCaptureComponentsMatchedByRegex:REGEX_MOD_DESC];
			
			// deal with course base first
			[returnvalues setObject:[JOURLRequest stringFromArray:courseBase outterIndex:1 innerIndex:1] forKey:@"title"];
			[returnvalues setObject:[JOURLRequest stringFromArray:courseBase outterIndex:2 innerIndex:1] forKey:@"au"];
			[returnvalues setObject:[JOURLRequest stringFromArray:courseBase outterIndex:3 innerIndex:1] forKey:@"runBy"];
			
			// next special req shit
			[returnvalues setObject:[JOURLRequest stringsFromArray:courseSpecialReq forKey:MOD_MATCH_PREREQ] forKey:@"prerequisite"];
			[returnvalues setObject:[JOURLRequest stringsFromArray:courseSpecialReq forKey:MOD_MATCH_NOCORE] forKey:@"notAvailCORE"];
			[returnvalues setObject:[JOURLRequest stringsFromArray:courseSpecialReq forKey:MOD_MATCH_NOUE] forKey:@"notAvailUE"];
			[returnvalues setObject:[JOURLRequest stringsFromArray:courseSpecialReq forKey:MOD_MATCH_NOPE] forKey:@"notAvailPE"];
			
			// description
			[returnvalues setObject:[self stringFromArray:courseDesc outterIndex:0 innerIndex:1] forKey:@"details"];
			
			urlrequest.hasCompletionReturn = YES;
			returning = [[[JONTUCourse alloc] initWithModuleValues:returnvalues] autorelease];
			
		}
		[courseInfoStr release];
		return returning;

	};
	
	[urlrequest setPostProcessBlock:processblk];
	
	return [urlrequest autorelease];
}

-(id)initWithModuleValues:(NSDictionary *)values {
	if ((self = [super init])) {
		title = [[values objectForKey:@"title"] retain];
		au = [[values objectForKey:@"au"] intValue];
		runBy = [[values objectForKey:@"runBy"] retain];
		
		prerequisite = [[values objectForKey:@"prerequisite"] retain];
		notAvailPE = [[values objectForKey:@"notAvailPE"] retain];
		notAvailUE = [[values objectForKey:@"notAvailUE"] retain];
		notAvailCORE = [[values objectForKey:@"notAvailCORE"] retain];
		
		details = [[values objectForKey:@"details"] retain];
	}
	return self;
}

-(id)initWithTimeTableValues:(NSDictionary *)values {
	if ((self = [super init])) {
		
		// from timetable shit
		name = [[values objectForKey:@"name"] retain];
		au = [[values objectForKey:@"au"] intValue];
		type = [[values objectForKey:@"coursetype"] retain];
		su = [[values objectForKey:@"suopt"] retain];
		gepre = [[values objectForKey:@"gepretype"] retain];
		index = [[values objectForKey:@"indexNumber"] retain];
		status = [[values objectForKey:@"regstat"] retain];
		choice = [[values objectForKey:@"coursechoice"] intValue];
		
		semester = [[values objectForKey:@"semester"] retain];
		classes = [[values objectForKey:@"classes"] retain];
		
		// course info
		
		request = [JONTUCourse courseWithCode:name forYear:semester.year semester:semester.semester];
		request.completionBlock = ^(id _data, id _response, id _postprocessed) {
			JONTUCourse *course = (JONTUCourse *)_postprocessed;
			
			title = [course.title retain];
			runBy = [course.runBy retain];
			prerequisite = [course.prerequisite retain];
			notAvailUE = [course.notAvailUE retain];
			notAvailPE = [course.notAvailPE retain];
			notAvailCORE = [course.notAvailCORE retain];
			details = [course.details retain];
			
			[request release];
		};

	}
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
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

-(NSString *)description {
	return [NSString stringWithFormat:@"<NTUCourse: %@ with %i classes>",self.name, [self.classes count]];
}

-(NSUInteger)classesCount {
	return [self.classes count];
}

-(void)dealloc {
	[request release], request = nil;
	
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
