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
#import "JONTUClass.h"
#import "JONTUCourse.h"
#import "RegexKitLite.h"
#import "NSString+htmlentitiesaddition.h"

#define XHR_URL @"https://wish.wis.ntu.edu.sg/pls/webexe/aus_stars_check.check_subject_web2"
#define REGEX_TABLE @"<TABLE  border>\\s<TR>\\s<TD valign=\"BOTTOM\"><B>Course</B></TD>\\s<TD valign=\"BOTTOM\"><B>AU</B></TD>\\s<TD valign=\"BOTTOM\"><B>Course<BR>Type</B></TD>\\s<TD valign=\"BOTTOM\"><B>S/U Grade option</B></TD>\\s<TD valign=\"BOTTOM\"><B>General<BR>Prescribed<BR>Type</B></TD>\\s<TD valign=\"BOTTOM\"><B>Index<BR>Number</B></TD>\\s<TD valign=\"BOTTOM\"><B>Status</B></TD>\\s<TD valign=\"BOTTOM\"><B>Choice</B></TD>\\s<TD valign=\"BOTTOM\"><B>Class<BR>Type</B></TD>\\s<TD valign=\"BOTTOM\"><B>Group</B></TD>\\s<TD valign=\"BOTTOM\"><B>Day</B></TD>\\s<TD valign=\"BOTTOM\"><B>Time</B></TD>\\s<TD valign=\"BOTTOM\"><B>Venue</B></TD>\\s<TD valign=\"BOTTOM\"><B>Remark</B></TD>\\s</TR>([\\s\\S]*)</TABLE>"
#define REGEX_TABLE_ROW @"<TR><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD><TD>([ ,/\\.\\w-]*)</TD></TR>"
#define REGEX_SEM_LIST @"<FORM ACTION=\"aus_stars_check.check_subject_web2\" METHOD=\"POST\">\\s*<INPUT TYPE=\"button\" VALUE=\"(.*)\" onClick=\"submit\\(\\)\">\\s*<INPUT TYPE=\"hidden\" NAME=\"p1\" VALUE=\".*\">\\s*<INPUT TYPE=\"hidden\" NAME=\"p2\" VALUE=\".*\">\\s*<INPUT TYPE=\"hidden\" NAME=\"acad\" VALUE=\"([0-9]+)\">\\s*<INPUT TYPE=\"hidden\" NAME=\"semester\" VALUE=\"(.+)\">\\s*</FORM>"
@implementation JONTUSemester

@synthesize name, year, semester, courses;

-(id)initWithName:(NSString *)semname year:(NSUInteger)semyear semester:(NSString *)semsem {
	if (self = [super init]) {
		name = [semname retain];
		year = semyear;
		semester = [semsem retain];
	}
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super init]) {
		name = [[aDecoder decodeObjectForKey:@"name"] retain];
		year = [aDecoder decodeIntForKey:@"year"];
		semester = [[aDecoder decodeObjectForKey:@"semester"] retain];
		courses = [[aDecoder decodeObjectForKey:@"courses"] retain];
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:name forKey:@"name"];
	[aCoder encodeObject:semester forKey:@"semester"];
	[aCoder encodeObject:courses forKey:@"courses"];
	[aCoder encodeInt:year forKey:@"year"];
}

+(NSArray *)listSemestersOfUser:(NSString *)user password:(NSString *)pass domain:(NSString *)domain parseImmediately:(BOOL)parsenow {
	JONTUSemester *sem = [[JONTUSemester alloc] init];
	NSMutableArray *semList = [NSMutableArray array];
	[sem setUser:user];
	[sem setPass:pass];
	[sem setDomain:domain];
	
	NSLog(@"JONTUTimeTable: Begin login");
	
	if ([sem auth]) {
		NSLog(@"JONTUTimeTable: Login success. Getting list of semesters");
		NSString *html = [[NSString alloc] initWithData:[sem sendSyncXHRToURL:[NSURL URLWithString:XHR_URL] postValues:[NSDictionary dictionary] withToken:YES] encoding:NSUTF8StringEncoding];
		NSArray *sems = [html componentsMatchedByRegex:REGEX_SEM_LIST];

		NSLog(@"JONTUTimeTable: Creating Objects");
		NSArray *semDetail;
		JONTUSemester *newSem = nil;
		for (int i=0;i<[sems count];i++) {
			semDetail = [[sems objectAtIndex:i] captureComponentsMatchedByRegex:REGEX_SEM_LIST];			
			newSem = [[JONTUSemester alloc] initWithName:[semDetail objectAtIndex:1] year:[[semDetail objectAtIndex:2] intValue] semester:[semDetail objectAtIndex:3]];
			[newSem setUser:user];
			[newSem setPass:pass];
			[newSem setDomain:domain];
			
			if (parsenow) {
				[newSem parse];
			}
			
			[semList addObject:newSem];
			[newSem release], newSem = nil;
		}
		
		[html release];
	} else {
		NSLog(@"JONTUTimeTable: Login failure");

		semList = nil;
	}
	
	[sem release];
	return semList;
}

-(NSString *)description {
	return [NSString stringWithFormat:@"<NTUSemester: %@ with %i courses>",self.name, [self.courses count]];
}

-(NSUInteger)coursesCount {
	return [self.courses count];
}

-(NSUInteger)totalAU {
	int totalau = 0;
	for (JONTUCourse *cse in courses) {
		totalau += cse.au;
	}
	
	return totalau;
}

-(void)parse {
	if ([self auth]) {

		NSMutableDictionary *postvalues = [NSMutableDictionary dictionary];
		[postvalues setValue:[NSString stringWithFormat:@"%i",self.year] forKey:@"acad"];
		[postvalues setValue:self.semester forKey:@"semester"];
		
		NSLog(@"JONTUTimeTable: Retrieve timetable");

		NSString *html = [[NSString alloc] initWithData:[self sendSyncXHRToURL:[NSURL URLWithString:XHR_URL] postValues:postvalues withToken:YES] encoding:NSUTF8StringEncoding];
		NSArray *timetablelines = [[[[html stringByMatching:REGEX_TABLE capture:1] stringByReplacingOccurrencesOfString:@"\n" withString:@""] removeHTMLEntities] componentsMatchedByRegex:REGEX_TABLE_ROW];
		[html release];
		
		NSArray *timetableitems;
		NSMutableArray *t_courses = [NSMutableArray array];
		NSMutableArray *t_classes = nil;
		
		for (int i=0;i<[timetablelines count];i++) {
			timetableitems = [[timetablelines objectAtIndex:i] captureComponentsMatchedByRegex:REGEX_TABLE_ROW];
			
			// handle if its a row with course information
			if (![[timetableitems objectAtIndex:1] isEqualToString:@""]) {
				NSLog(@"JONTUTimeTable: Found course %@", [timetableitems objectAtIndex:1]);

				JONTUCourse *t_course = [[JONTUCourse alloc] initWithName:[timetableitems objectAtIndex:1]
														academicUnits:[[timetableitems objectAtIndex:2] intValue]
														   courseType:[timetableitems objectAtIndex:3]
															 suOption:[timetableitems objectAtIndex:4]
															gePreType:[timetableitems objectAtIndex:5]
														  indexNumber:[timetableitems objectAtIndex:6]
												   registrationStatus:[timetableitems objectAtIndex:7]
															   choice:[[timetableitems objectAtIndex:8] intValue]
													pullAditionalInfo:NO];
				t_course.semester = self;
				
				[t_courses addObject:t_course];
				[t_course release], t_course = nil;
				t_classes = [NSMutableArray array];
			}
			
			// deal with class information
		   NSLog(@"JONTUTimeTable: Found class %@", [timetableitems objectAtIndex:9]);

			JONTUClass *t_class = [[JONTUClass alloc] initWithType:[timetableitems objectAtIndex:9]
													classGroup:[timetableitems objectAtIndex:10]
														 venue:[timetableitems objectAtIndex:13]
														remark:[timetableitems objectAtIndex:14] 
														   day:[timetableitems objectAtIndex:11] 
														  time:[timetableitems objectAtIndex:12]];
			[t_classes addObject:t_class];		
			[t_class release], t_class = nil;	
			
			((JONTUCourse *)[t_courses lastObject]).classes = t_classes;
		}
		courses = [t_courses retain];
		
	} else {
		NSLog(@"Could not auth");
	}
}

-(void)dealloc {
	[name release], name = nil;
	[semester release], semester = nil;
	[courses release], courses = nil;
	[super dealloc];
}

@end
