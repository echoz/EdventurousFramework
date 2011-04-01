//
//  JONTUCourse.m
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

#import "JONTUCourse.h"
#import "JONTUCourseDetails.h"

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

+(JONTUCourse *)courseWithCode:(NSString *)code forSemester:(JONTUSemester *)semester managedContext:(NSManagedObjectContext *)moc {
	NSSet *results = [moc fetchObjectsForEntityName:[JONTUCourse entityName] withPredicate:@"(code == %@) AND (semester == %@)", code, semester];
	
	if ([results count] == 1) {
		return [results anyObject];
	} else {
		JONTUCourse *course = [[JONTUCourse alloc] initWithEntity:[NSEntityDescription entityForName:[JONTUCourse entityName] inManagedObjectContext:moc]
								   insertIntoManagedObjectContext:moc];
		
		course.semester = semester;
		course.code = code;
		course.detail = [JONTUCourseDetails courseWithCode:code semester:semester managedContext:moc];
		
		return [course autorelease];
	}
}

#pragma mark -
#pragma mark Overrides for setting classes and its count

-(void)setClasses:(NSSet *)classes {
	[super setClasses:classes];
	self.classesCountValue = [self.classes count];
}

-(void)addClassesObject:(JONTUClass *)value_ {
	[super addClassesObject:value_];
	self.classesCountValue = [self.classes count];
}

-(void)addClasses:(NSSet *)value_ {
	[super addClasses:value_];
	self.classesCountValue = [self.classes count];
}

@end
