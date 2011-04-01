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

	return keyPaths;
}




@dynamic status;






@dynamic gepre;






@dynamic type;






@dynamic choice;






@dynamic su;






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





@dynamic name;






@dynamic index;






@dynamic classes;

	

@dynamic semester;

	





@end
