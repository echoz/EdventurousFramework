//
//  NTUCourse.h
//  NTUAuth
//
//  Created by Jeremy Foo on 8/4/10.
//  Copyright 2010 ORNYX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JONTUSemester.h"

@interface JONTUCourse : NSObject <NSCoding> {
	
	// from time table
	NSString *name;
	NSUInteger au;
	NSString *type;
	NSString *su;
	NSString *gepre;
	NSString *index;
	NSString *status;
	NSUInteger choice;
	
	// from module information
	NSString *title;
	NSString *runBy;
	NSArray *mutuallyExclusive;
	NSArray *prerequisite;
	NSArray *notAvailUE;
	NSArray *notAvailPE;
	NSString *details;
	
	NSArray *classes;
	
	JONTUSemester *semester;
}

@property (readonly) NSString *name;
@property (readonly) NSUInteger au;
@property (readonly) NSString *type;
@property (readonly) NSString *su;
@property (readonly) NSString *gepre;
@property (readonly) NSString *index;
@property (readonly) NSString *status;
@property (readonly) NSUInteger choice;
@property (nonatomic, retain) NSArray *classes;

@property (readonly) NSString *title;
@property (readonly) NSString *runBy;
@property (readonly) NSArray *prerequisite;
@property (readonly) NSArray *notAvailUE;
@property (readonly) NSArray *notAvailPE;
@property (readonly) NSString *details;

@property (assign) JONTUSemester *semester;

-(id)initWithName:(NSString *)coursename academicUnits:(NSUInteger) acadunit courseType:(NSString *)coursetype suOption:(NSString *)suopt gePreType:(NSString *)gepretype indexNumber:(NSString *)indexNumber registrationStatus:(NSString *)regstat choice:(NSUInteger) coursechoice pullAditionalInfo:(BOOL)additionalInfo;
-(NSUInteger)classesCount;
-(void)parseModuleInfo;
@end
