// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JONTUCourseDetails.m instead.

#import "_JONTUCourseDetails.h"

@implementation JONTUCourseDetailsID
@end

@implementation _JONTUCourseDetails

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"JONTUCourseDetails" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"JONTUCourseDetails";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"JONTUCourseDetails" inManagedObjectContext:moc_];
}

- (JONTUCourseDetailsID*)objectID {
	return (JONTUCourseDetailsID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"infantValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"infant"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"parsedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"parsed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic lastParsed;






@dynamic notAvailUE;






@dynamic prereq;






@dynamic birthDate;






@dynamic lastAccessed;






@dynamic title;






@dynamic notAvailCORE;






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





@dynamic mutex;






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





@dynamic notAvailPE;






@dynamic details;






@dynamic code;






@dynamic runBy;






@dynamic semester;

	

@dynamic courses;

	
- (NSMutableSet*)coursesSet {
	[self willAccessValueForKey:@"courses"];
	NSMutableSet *result = [self mutableSetValueForKey:@"courses"];
	[self didAccessValueForKey:@"courses"];
	return result;
}
	





@end
