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



@property (nonatomic, retain) NSDate *birthDate;

//- (BOOL)validateBirthDate:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSObject *semesters;

//- (BOOL)validateSemesters:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *lastAccessed;

//- (BOOL)validateLastAccessed:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *infant;

@property BOOL infantValue;
- (BOOL)infantValue;
- (void)setInfantValue:(BOOL)value_;

//- (BOOL)validateInfant:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *year;

@property int yearValue;
- (int)yearValue;
- (void)setYearValue:(int)value_;

//- (BOOL)validateYear:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *parsed;

@property BOOL parsedValue;
- (BOOL)parsedValue;
- (void)setParsedValue:(BOOL)value_;

//- (BOOL)validateParsed:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *lastParsed;

//- (BOOL)validateLastParsed:(id*)value_ error:(NSError**)error_;





@end

@interface _JONTUSemesterDates (CoreDataGeneratedAccessors)

@end

@interface _JONTUSemesterDates (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveBirthDate;
- (void)setPrimitiveBirthDate:(NSDate*)value;




- (NSObject*)primitiveSemesters;
- (void)setPrimitiveSemesters:(NSObject*)value;




- (NSDate*)primitiveLastAccessed;
- (void)setPrimitiveLastAccessed:(NSDate*)value;




- (NSNumber*)primitiveInfant;
- (void)setPrimitiveInfant:(NSNumber*)value;

- (BOOL)primitiveInfantValue;
- (void)setPrimitiveInfantValue:(BOOL)value_;




- (NSNumber*)primitiveYear;
- (void)setPrimitiveYear:(NSNumber*)value;

- (int)primitiveYearValue;
- (void)setPrimitiveYearValue:(int)value_;




- (NSNumber*)primitiveParsed;
- (void)setPrimitiveParsed:(NSNumber*)value;

- (BOOL)primitiveParsedValue;
- (void)setPrimitiveParsedValue:(BOOL)value_;




- (NSDate*)primitiveLastParsed;
- (void)setPrimitiveLastParsed:(NSDate*)value;




@end
