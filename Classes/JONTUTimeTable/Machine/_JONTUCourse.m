// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JONTUCourse.m instead.

#import "_JONTUCourse.h"

@implementation JONTUCourseID
@end

@implementation _JONTUCourse

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"JONTUCourse" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"JONTUCourse";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"JONTUCourse" inManagedObjectContext:moc_];
}

- (JONTUCourseID*)objectID {
	return (JONTUCourseID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"infantValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"infant"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"classesCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"classesCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"parsedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"parsed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"auValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"au"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic lastParsed;






@dynamic gepre;






@dynamic birthDate;






@dynamic lastAccessed;






@dynamic type;






@dynamic choice;






@dynamic su;






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





@dynamic classesCount;



- (int)classesCountValue {
	NSNumber *result = [self classesCount];
	return [result intValue];
}

- (void)setClassesCountValue:(int)value_ {
	[self setClassesCount:[NSNumber numberWithInt:value_]];
}

- (int)primitiveClassesCountValue {
	NSNumber *result = [self primitiveClassesCount];
	return [result intValue];
}

- (void)setPrimitiveClassesCountValue:(int)value_ {
	[self setPrimitiveClassesCount:[NSNumber numberWithInt:value_]];
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





@dynamic index;






@dynamic au;



- (short)auValue {
	NSNumber *result = [self au];
	return [result shortValue];
}

- (void)setAuValue:(short)value_ {
	[self setAu:[NSNumber numberWithShort:value_]];
}

- (short)primitiveAuValue {
	NSNumber *result = [self primitiveAu];
	return [result shortValue];
}

- (void)setPrimitiveAuValue:(short)value_ {
	[self setPrimitiveAu:[NSNumber numberWithShort:value_]];
}





@dynamic code;






@dynamic status;






@dynamic classes;

	
- (NSMutableSet*)classesSet {
	[self willAccessValueForKey:@"classes"];
	NSMutableSet *result = [self mutableSetValueForKey:@"classes"];
	[self didAccessValueForKey:@"classes"];
	return result;
}
	

@dynamic semester;

	

@dynamic detail;

	





@end
