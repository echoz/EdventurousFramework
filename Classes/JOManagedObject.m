//
//  JOManagedObject.m
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
#import "JOManagedObject.h"


@implementation JOManagedObject

#pragma mark -
#pragma mark NSManagedObject lifecycle

-(void)awakeFromInsert {
	[super awakeFromInsert];
	self.infantValue = YES;
	self.birthDate = [NSDate date];
}

-(void)awakeFromFetch {
	[super awakeFromFetch];
	self.lastAccessed = [NSDate date];
}

-(void)didTurnIntoFault {
	[self stopSync];
	[super didTurnIntoFault];
}

#pragma mark -
#pragma mark Syncing

-(void)stopSync {
	[__request cancel];
	[__request release], __request = nil;
}

-(BOOL)syncWithPolicy:(JOManagedObjectSyncPolicy)policy {
	[NSException raise:NSInternalInconsistencyException
				format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return NO;
}

#pragma mark -
#pragma mark MOGEN STUFF


@dynamic birthDate;
@dynamic lastAccessed;
@dynamic parsed;
@dynamic lastParsed;
@dynamic infant;

- (BOOL)parsedValue {
	NSNumber *result = [self parsed];
	return [result boolValue];
}

- (void)setParsedValue:(BOOL)value_ {
	[self setParsed:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveParsedValue {
	NSNumber *result = [self primitiveParsed];
	return [result boolValue];
}

- (void)setPrimitiveParsedValue:(BOOL)value_ {
	[self setPrimitiveParsed:[NSNumber numberWithBool:value_]];
}

- (BOOL)infantValue {
	NSNumber *result = [self infant];
	return [result boolValue];
}

- (void)setInfantValue:(BOOL)value_ {
	[self setInfant:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveInfantValue {
	NSNumber *result = [self primitiveInfant];
	return [result boolValue];
}

- (void)setPrimitiveInfantValue:(BOOL)value_ {
	[self setPrimitiveInfant:[NSNumber numberWithBool:value_]];
}


@end
