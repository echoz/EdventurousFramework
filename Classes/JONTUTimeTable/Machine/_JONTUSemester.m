// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JONTUSemester.m instead.

#import "_JONTUSemester.h"

@implementation JONTUSemesterID
@end

@implementation _JONTUSemester

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"JONTUSemester" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"JONTUSemester";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"JONTUSemester" inManagedObjectContext:moc_];
}

- (JONTUSemesterID*)objectID {
	return (JONTUSemesterID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"infantValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"infant"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"coursesCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"coursesCount"];
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





@dynamic coursesCount;



- (long long)coursesCountValue {
	NSNumber *result = [self coursesCount];
	return [result longLongValue];
}

- (void)setCoursesCountValue:(long long)value_ {
	[self setCoursesCount:[NSNumber numberWithLongLong:value_]];
}

- (long long)primitiveCoursesCountValue {
	NSNumber *result = [self primitiveCoursesCount];
	return [result longLongValue];
}

- (void)setPrimitiveCoursesCountValue:(long long)value_ {
	[self setPrimitiveCoursesCount:[NSNumber numberWithLongLong:value_]];
}





@dynamic year;



- (long long)yearValue {
	NSNumber *result = [self year];
	return [result longLongValue];
}

- (void)setYearValue:(long long)value_ {
	[self setYear:[NSNumber numberWithLongLong:value_]];
}

- (long long)primitiveYearValue {
	NSNumber *result = [self primitiveYear];
	return [result longLongValue];
}

- (void)setPrimitiveYearValue:(long long)value_ {
	[self setPrimitiveYear:[NSNumber numberWithLongLong:value_]];
}





@dynamic name;






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





@dynamic semester;






@dynamic lastParsed;






@dynamic courseDetails;

	
- (NSMutableSet*)courseDetailsSet {
	[self willAccessValueForKey:@"courseDetails"];
	NSMutableSet *result = [self mutableSetValueForKey:@"courseDetails"];
	[self didAccessValueForKey:@"courseDetails"];
	return result;
}
	

@dynamic courses;

	
- (NSMutableSet*)coursesSet {
	[self willAccessValueForKey:@"courses"];
	NSMutableSet *result = [self mutableSetValueForKey:@"courses"];
	[self didAccessValueForKey:@"courses"];
	return result;
}
	





@end
