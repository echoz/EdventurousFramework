// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JONTUSemesterDates.h instead.

#import <CoreData/CoreData.h>
#import "JOManagedObject.h"



@class NSObject;

@interface JONTUSemesterDatesID : NSManagedObjectID {}
@end

@interface _JONTUSemesterDates : JOManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (JONTUSemesterDatesID*)objectID;



@property (nonatomic, retain) NSNumber *year;

@property int yearValue;
- (int)yearValue;
- (void)setYearValue:(int)value_;

//- (BOOL)validateYear:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSObject *semesters;

//- (BOOL)validateSemesters:(id*)value_ error:(NSError**)error_;





@end

@interface _JONTUSemesterDates (CoreDataGeneratedAccessors)

@end

@interface _JONTUSemesterDates (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveYear;
- (void)setPrimitiveYear:(NSNumber*)value;

- (int)primitiveYearValue;
- (void)setPrimitiveYearValue:(int)value_;




- (NSObject*)primitiveSemesters;
- (void)setPrimitiveSemesters:(NSObject*)value;




@end
