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
	
	if ([key isEqualToString:@"yearValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"year"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
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





@dynamic semesters;










@end
