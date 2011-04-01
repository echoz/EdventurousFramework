// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JONTUClass.h instead.

#import <CoreData/CoreData.h>
#import "JOManagedObject.h"

@class JONTUCourse;













@interface JONTUClassID : NSManagedObjectID {}
@end

@interface _JONTUClass : JOManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (JONTUClassID*)objectID;



@property (nonatomic, retain) NSDate *birthDate;

//- (BOOL)validateBirthDate:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *remark;

//- (BOOL)validateRemark:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *lastAccessed;

//- (BOOL)validateLastAccessed:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *day;

//- (BOOL)validateDay:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *group;

//- (BOOL)validateGroup:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *infant;

@property BOOL infantValue;
- (BOOL)infantValue;
- (void)setInfantValue:(BOOL)value_;

//- (BOOL)validateInfant:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *venue;

//- (BOOL)validateVenue:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *time;

//- (BOOL)validateTime:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *parsed;

@property BOOL parsedValue;
- (BOOL)parsedValue;
- (void)setParsedValue:(BOOL)value_;

//- (BOOL)validateParsed:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *lastParsed;

//- (BOOL)validateLastParsed:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) JONTUCourse* course;
//- (BOOL)validateCourse:(id*)value_ error:(NSError**)error_;




@end

@interface _JONTUClass (CoreDataGeneratedAccessors)

@end

@interface _JONTUClass (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveBirthDate;
- (void)setPrimitiveBirthDate:(NSDate*)value;




- (NSString*)primitiveRemark;
- (void)setPrimitiveRemark:(NSString*)value;




- (NSDate*)primitiveLastAccessed;
- (void)setPrimitiveLastAccessed:(NSDate*)value;




- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;




- (NSString*)primitiveDay;
- (void)setPrimitiveDay:(NSString*)value;




- (NSString*)primitiveGroup;
- (void)setPrimitiveGroup:(NSString*)value;




- (NSNumber*)primitiveInfant;
- (void)setPrimitiveInfant:(NSNumber*)value;

- (BOOL)primitiveInfantValue;
- (void)setPrimitiveInfantValue:(BOOL)value_;




- (NSString*)primitiveVenue;
- (void)setPrimitiveVenue:(NSString*)value;




- (NSString*)primitiveTime;
- (void)setPrimitiveTime:(NSString*)value;




- (NSNumber*)primitiveParsed;
- (void)setPrimitiveParsed:(NSNumber*)value;

- (BOOL)primitiveParsedValue;
- (void)setPrimitiveParsedValue:(BOOL)value_;




- (NSDate*)primitiveLastParsed;
- (void)setPrimitiveLastParsed:(NSDate*)value;





- (JONTUCourse*)primitiveCourse;
- (void)setPrimitiveCourse:(JONTUCourse*)value;


@end
