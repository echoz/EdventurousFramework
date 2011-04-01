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
	
	if ([key isEqualToString:@"semesterValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"semester"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic year;






@dynamic name;






@dynamic semester;



- (int)semesterValue {
	NSNumber *result = [self semester];
	return [result intValue];
}

- (void)setSemesterValue:(int)value_ {
	[self setSemester:[NSNumber numberWithInt:value_]];
}

- (int)primitiveSemesterValue {
	NSNumber *result = [self primitiveSemester];
	return [result intValue];
}

- (void)setPrimitiveSemesterValue:(int)value_ {
	[self setPrimitiveSemester:[NSNumber numberWithInt:value_]];
}





@dynamic courses;

	
- (NSMutableSet*)coursesSet {
	[self willAccessValueForKey:@"courses"];
	NSMutableSet *result = [self mutableSetValueForKey:@"courses"];
	[self didAccessValueForKey:@"courses"];
	return result;
}
	





@end
