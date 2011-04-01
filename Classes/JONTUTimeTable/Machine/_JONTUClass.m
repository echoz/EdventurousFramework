// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JONTUClass.m instead.

#import "_JONTUClass.h"

@implementation JONTUClassID
@end

@implementation _JONTUClass

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"JONTUClass" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"JONTUClass";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"JONTUClass" inManagedObjectContext:moc_];
}

- (JONTUClassID*)objectID {
	return (JONTUClassID*)[super objectID];
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




@dynamic birthDate;






@dynamic remark;






@dynamic lastAccessed;






@dynamic type;






@dynamic day;






@dynamic group;






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





@dynamic venue;






@dynamic time;






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






@dynamic course;

	





@end
