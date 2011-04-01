// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JONTUSemesterDates.m instead.

#import "_JONTUSemesterDates.h"

@implementation JONTUSemesterDatesID
@end

@implementation _JONTUSemesterDates

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"JONTUSemesterDates" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"JONTUSemesterDates";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"JONTUSemesterDates" inManagedObjectContext:moc_];
}

- (JONTUSemesterDatesID*)objectID {
	return (JONTUSemesterDatesID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"infantValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"infant"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"yearValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"year"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"parsedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"parsed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic birthDate;






@dynamic semesters;






@dynamic lastAccessed;






@dynamic infant;



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





@dynamic year;



- (int)yearValue {
	NSNumber *result = [self year];
	return [result intValue];
}

- (void)setYearValue:(int)value_ {
	[self setYear:[NSNumber numberWithInt:value_]];
}

- (int)primitiveYearValue {
	NSNumber *result = [self primitiveYear];
	return [result intValue];
}

- (void)setPrimitiveYearValue:(int)value_ {
	[self setPrimitiveYear:[NSNumber numberWithInt:value_]];
}





@dynamic parsed;



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





@dynamic lastParsed;










@end
