//
//  JONTUSemesterDates.h
//  JONTUTimeTable
//
//  Created by Jeremy Foo on 9/1/10.
//  Copyright 2010 ORNYX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JONTUAuth.h"

@interface JONTUSemesterDates : JONTUAuth {
	NSUInteger year;
	
	NSDictionary *semesters;
}
@property (readonly) NSDictionary *semesters;
@property (readonly) NSUInteger year;
-(id)initWithYear:(NSUInteger)yr;
-(void)parse;
-(NSDictionary *)semesterWithCode:(NSString *)code;

@end
