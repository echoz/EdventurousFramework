//
//  JONTUSemester.m
//  JONTUTimeTable
//
//  Created by Jeremy Foo on 8/5/10.
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

#import "JONTUSemester.h"
#import "JONTUCourse.h"
#import "RegexKitLite.h"

#define XHR_URL @"https://wish.wis.ntu.edu.sg/pls/webexe/aus_stars_check.check_subject_web2"
#define REGEX_TABLE @"<TABLE  border>\\s<TR>\\s<TD valign=\"BOTTOM\"><B>Course</B></TD>\\s<TD valign=\"BOTTOM\"><B>AU</B></TD>\\s<TD valign=\"BOTTOM\"><B>Course<BR>Type</B></TD>\\s<TD valign=\"BOTTOM\"><B>S/U Grade option</B></TD>\\s<TD valign=\"BOTTOM\"><B>GER<BR>Type</B></TD>\\s<TD valign=\"BOTTOM\"><B>Index<BR>Number</B></TD>\\s<TD valign=\"BOTTOM\"><B>Status</B></TD>\\s<TD valign=\"BOTTOM\"><B>Choice</B></TD>\\s<TD valign=\"BOTTOM\"><B>Class<BR>Type</B></TD>\\s<TD valign=\"BOTTOM\"><B>Group</B></TD>\\s<TD valign=\"BOTTOM\"><B>Day</B></TD>\\s<TD valign=\"BOTTOM\"><B>Time</B></TD>\\s<TD valign=\"BOTTOM\"><B>Venue</B></TD>\\s<TD valign=\"BOTTOM\"><B>Remark</B></TD>\\s</TR>([\\s\\S]*)</TABLE>"
#define REGEX_TABLE_ROW @"<TR><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD></TR>"
#define REGEX_SEM_LIST @"<FORM ACTION=\"aus_stars_check.check_subject_web2\" METHOD=\"POST\">\\s*<INPUT TYPE=\"button\" VALUE=\"(.*)\" onClick=\"submit\\(\\)\">\\s*<INPUT TYPE=\"hidden\" NAME=\"p1\" VALUE=\".*\">\\s*<INPUT TYPE=\"hidden\" NAME=\"p2\" VALUE=\".*\">\\s*<INPUT TYPE=\"hidden\" NAME=\"acad\" VALUE=\"([0-9]+)\">\\s*<INPUT TYPE=\"hidden\" NAME=\"semester\" VALUE=\"(.+)\">\\s*</FORM>"

@implementation JONTUSemester

#pragma mark -
#pragma mark Object lifecycle
@synthesize auth = __auth;

-(void)didTurnIntoFault {
	[__auth release], __auth = nil;
	[super didTurnIntoFault];
}

+(JONTUSemester *)semesterWithYear:(NSInteger)year semester:(NSString *)sem managedContext:(NSManagedObjectContext *)moc {
	NSSet *results = [moc fetchObjectsForEntityName:[JONTUSemester entityName] withPredicate:@"(year == %@) AND (semester == %@)", year, sem];
	
	if ([results count] == 1) {
		return [results anyObject];
	} else {
		JONTUSemester *semester = [[JONTUSemester alloc] initWithEntity:[NSEntityDescription entityForName:[JONTUSemester entityName] inManagedObjectContext:moc]
										 insertIntoManagedObjectContext:moc];
		
		semester.yearValue = year;
		semester.semester = sem;
		
		return [semester autorelease];
	}
}

#pragma mark -
#pragma mark Easy Methods

+(JOURLRequest *)semestersWithAuth:(JONTUAuth *)auth parseNow:(BOOL)parsenow managedContext:(NSManagedObjectContext *)moc {
	JOURLRequest *semlistrequest = nil;
	
	if ([auth authed]) {
		semlistrequest = [auth authedJORequestForURL:[NSURL URLWithString:XHR_URL] withValues:nil usingTokens:YES];
		semlistrequest.postProcessBlock = ^(id _data, id _response) {
			NSString *semsString = [[NSString alloc] initWithData:(NSData *)_data encoding:NSUTF8StringEncoding];
			NSArray *sems = [semsString componentsMatchedByRegex:REGEX_SEM_LIST];
			[semsString release];
			
			NSMutableArray *semlist = [NSMutableArray arrayWithCapacity:0];
			NSArray *semDetail = nil;
			JONTUSemester *newSem = nil;
			
			for (int i=0;i<[sems count];i++) {
				semDetail = [[sems objectAtIndex:i] captureComponentsMatchedByRegex:REGEX_SEM_LIST];
				
				// might need ot think of deleting everything related to the current semester being entered or a merge
				
				newSem = [JONTUSemester semesterWithYear:[[semDetail objectAtIndex:2] integerValue] semester:[semDetail objectAtIndex:3] managedContext:moc];
				newSem.name = [semDetail objectAtIndex:1];
				
				newSem.auth = auth;
				
				if (parsenow) {
					[newSem parse];
				}
				
				[semlist addObject:newSem];
				
			}
			
			semlistrequest.hasCompletionReturn = YES;
			
			return semlist;

		};
	}
	
	return semlistrequest;
}

-(void)parse {
	if ([__auth authed]) {
		NSMutableDictionary *postvalues = [NSMutableDictionary dictionary];
		[postvalues setValue:[NSString stringWithFormat:@"%i",self.year] forKey:@"acad"];
		[postvalues setValue:self.semester forKey:@"semester"];

		__request = [__auth authedJORequestForURL:[NSURL URLWithString:XHR_URL] withValues:postvalues usingTokens:YES];
		
		__request.postProcessBlock = ^(id _data, id _response) {
			NSString *html = [[NSString alloc] initWithData:(NSData *)_data encoding:NSUTF8StringEncoding];
			NSArray *timetablelines = [html stringByMatching:REGEX_TABLE capture:1];
			
			return (id)nil;
		};
	}
}


#pragma mark -
#pragma mark Overrides for setting classes and its count

-(void)setCourses:(NSSet *)courses {
	[super setCourses:courses];
	self.coursesCountValue = [self.courses count];
}

-(void)addCourses:(NSSet *)value_ {
	[super addCourses:value_];
	self.coursesCountValue = [self.courses count];
}

-(void)addCoursesObject:(JONTUCourse *)value_ {
	[super addCoursesObject:value_];
	self.coursesCountValue = [self.courses count];
}

#pragma mark -
#pragma mark Instance Methods

-(NSUInteger)totalAU {
	int totalau = 0;
	for (JONTUCourse *cse in self.courses) {
		totalau += cse.auValue;
	}
	
	return totalau;
}

@end
