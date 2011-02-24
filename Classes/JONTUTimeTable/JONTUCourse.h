//
//  JONTUCourse.h
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

#import <Foundation/Foundation.h>
#import "JONTUSemester.h"
#import "JOURLRequest.h"

@interface JONTUCourse : NSObject <NSCoding> {
	
	JOURLRequest *request;	
	
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
	NSArray *notAvailCORE;
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
@property (readonly) NSArray *notAvailCORE;
@property (readonly) NSString *details;

@property (nonatomic, retain) JONTUSemester *semester;

+(JOURLRequest *)courseWithCode:(NSString *)code forYear:(NSUInteger)year semester:(NSString *)sem;
-(id)initWithTimeTableValues:(NSDictionary *)values;
-(id)initWithModuleValues:(NSDictionary *)values;

-(NSUInteger)classesCount;
@end
