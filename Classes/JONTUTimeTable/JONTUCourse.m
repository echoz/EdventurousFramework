//
//  NTUCourse.m
//  NTUAuth
//
//  Created by Jeremy Foo on 8/4/10.
//  Copyright 2010 ORNYX. All rights reserved.
//

#import "JONTUCourse.h"

#define QUERY_URL @"https://wish.wis.ntu.edu.sg/webexe/owa/AUS_SUBJ_CONT.main_display1"

@implementation JONTUCourse

@synthesize name, au, type, su, gepre, index, status, choice, classes;
@synthesize title, runBy, prerequisite, notAvailPE, notAvailUE, details;
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
			[self parseModuleInfo];
		}
	}
	
	return self;
}

-(id)initWithCourseCode:(NSString *)ccode {
	if (self = [super init]) {
		name = [ccode retain];
		[self parseModuleInfo];
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
	[aCoder encodeObject:details forKey:@"details"];

}

-(void)parseModuleInfo {
	NSMutableDictionary *postValues = [NSMutableDictionary dictionary];
	[postValues setObject:[semester semester] forKey:@"semester"];
	[postValues setObject:[NSString stringWithFormat:@"%i",[semester year]] forKey:@"acad"];
	[postValues setObject:[NSString stringWithFormat:@"%i_%@",[semester year], [semester semester]] forKey:@"acadsem"];
	
	[semester sendSyncXHRToURL:[NSURL URLWithString:QUERY_URL] postValues:postValues withToken:NO];
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
	[details release], details = nil;
	
	[super dealloc];
}

@end
