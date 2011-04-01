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
	

	return keyPaths;
}




@dynamic type;






@dynamic venue;






@dynamic group;






@dynamic time;






@dynamic day;






@dynamic remark;






@dynamic course;

	





@end
