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
	
	if ([key isEqualToString:@"auValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"au"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"classesCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"classesCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




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





@dynamic type;






@dynamic su;






@dynamic choice;






@dynamic index;






@dynamic code;






@dynamic status;






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





@dynamic gepre;






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
