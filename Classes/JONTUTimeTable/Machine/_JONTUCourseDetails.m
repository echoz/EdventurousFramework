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
	

	return keyPaths;
}




@dynamic mutex;






@dynamic title;






@dynamic prereq;






@dynamic notAvailCORE;






@dynamic runBy;






@dynamic notAvailPE;






@dynamic details;






@dynamic notAvailUE;










@end
