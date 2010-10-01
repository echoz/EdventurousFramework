//
//  NTUSemester.h
//  NTUAuth
//
//  Created by Jeremy Foo on 8/5/10.
//  Copyright 2010 ORNYX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JONTUAuth.h"

@interface JONTUSemester : JONTUAuth <NSCoding> {
	NSString *name;
	NSUInteger year;
	NSString *semester;
	NSArray *courses;
}

@property (readonly) NSString *name;
@property (readonly) NSUInteger year;
@property (readonly) NSString *semester;
@property (readonly) NSArray *courses;
+(NSArray *)listSemestersOfUser:(NSString *)user password:(NSString *)pass domain:(NSString *)domain parseImmediately:(BOOL)parsenow;
-(id)initWithName:(NSString *)semname year:(NSUInteger)semyear semester:(NSString *)semester;
-(void)parse;
-(NSUInteger)coursesCount;
-(NSUInteger)totalAU;
@end
