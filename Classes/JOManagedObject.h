//
//  JOManagedObject.h
//  JOManagedObject
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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JOURLRequest.h"
#import "NSManagedObjectContextAdditions.h"

typedef enum {
	JOManagedObjectNotSyncingStatus = 0,
	JOManagedObjectSyncingStatus = 1,
	JOManagedObjectSyncErrorStatus = 100
} JOManagedObjectSyncStatus;

typedef enum {
	JOManagedObjectReplaceLocalPolicy = 1,
	JOManagedObjectReplaceRemotePolicy = 2
} JOManagedObjectSyncPolicy;

@interface JOManagedObject : NSManagedObject {
	JOManagedObjectSyncStatus __syncStats;
	JOURLRequest *__request;
}

-(void)stopSync;
-(BOOL)syncWithPolicy:(JOManagedObjectSyncPolicy)policy;

/*******************************************************************************
 * from mogen
 */


@property (nonatomic, retain) NSDate *birthDate;

//- (BOOL)validateBirthDate:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *lastAccessed;

//- (BOOL)validateLastAccessed:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *parsed;

@property BOOL parsedValue;
- (BOOL)parsedValue;
- (void)setParsedValue:(BOOL)value_;

//- (BOOL)validateParsed:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *lastParsed;

//- (BOOL)validateLastParsed:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *infant;

@property BOOL infantValue;
- (BOOL)infantValue;
- (void)setInfantValue:(BOOL)value_;

//- (BOOL)validateInfant:(id*)value_ error:(NSError**)error_;


@end

#pragma mark -
#pragma mark From MOGEN

@interface JOManagedObject (CoreDataGeneratedAccessors)

@end

@interface JOManagedObject (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveBirthDate;
- (void)setPrimitiveBirthDate:(NSDate*)value;

- (NSDate*)primitiveLastAccessed;
- (void)setPrimitiveLastAccessed:(NSDate*)value;

- (NSNumber*)primitiveParsed;
- (void)setPrimitiveParsed:(NSNumber*)value;

- (BOOL)primitiveParsedValue;
- (void)setPrimitiveParsedValue:(BOOL)value_;

- (NSDate*)primitiveLastParsed;
- (void)setPrimitiveLastParsed:(NSDate*)value;

- (NSNumber*)primitiveInfant;
- (void)setPrimitiveInfant:(NSNumber*)value;

- (BOOL)primitiveInfantValue;
- (void)setPrimitiveInfantValue:(BOOL)value_;


@end
