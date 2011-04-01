// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JONTUCourse.h instead.

#import <CoreData/CoreData.h>
#import "JOManagedObject.h"

@class JONTUClass;
@class JONTUSemester;
@class JONTUCourseDetails;
















@interface JONTUCourseID : NSManagedObjectID {}
@end

@interface _JONTUCourse : JOManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (JONTUCourseID*)objectID;



@property (nonatomic, retain) NSDate *lastParsed;

//- (BOOL)validateLastParsed:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *gepre;

//- (BOOL)validateGepre:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *birthDate;

//- (BOOL)validateBirthDate:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *lastAccessed;

//- (BOOL)validateLastAccessed:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *choice;

//- (BOOL)validateChoice:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *su;

//- (BOOL)validateSu:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *infant;

@property BOOL infantValue;
- (BOOL)infantValue;
- (void)setInfantValue:(BOOL)value_;

//- (BOOL)validateInfant:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *classesCount;

@property int classesCountValue;
- (int)classesCountValue;
- (void)setClassesCountValue:(int)value_;

//- (BOOL)validateClassesCount:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *parsed;

@property BOOL parsedValue;
- (BOOL)parsedValue;
- (void)setParsedValue:(BOOL)value_;

//- (BOOL)validateParsed:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *index;

//- (BOOL)validateIndex:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *au;

@property short auValue;
- (short)auValue;
- (void)setAuValue:(short)value_;

//- (BOOL)validateAu:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *code;

//- (BOOL)validateCode:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *status;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* classes;
- (NSMutableSet*)classesSet;



@property (nonatomic, retain) JONTUSemester* semester;
//- (BOOL)validateSemester:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) JONTUCourseDetails* detail;
//- (BOOL)validateDetail:(id*)value_ error:(NSError**)error_;




@end

@interface _JONTUCourse (CoreDataGeneratedAccessors)

- (void)addClasses:(NSSet*)value_;
- (void)removeClasses:(NSSet*)value_;
- (void)addClassesObject:(JONTUClass*)value_;
- (void)removeClassesObject:(JONTUClass*)value_;

@end

@interface _JONTUCourse (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveLastParsed;
- (void)setPrimitiveLastParsed:(NSDate*)value;




- (NSString*)primitiveGepre;
- (void)setPrimitiveGepre:(NSString*)value;




- (NSDate*)primitiveBirthDate;
- (void)setPrimitiveBirthDate:(NSDate*)value;




- (NSDate*)primitiveLastAccessed;
- (void)setPrimitiveLastAccessed:(NSDate*)value;




- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;




- (NSString*)primitiveChoice;
- (void)setPrimitiveChoice:(NSString*)value;




- (NSString*)primitiveSu;
- (void)setPrimitiveSu:(NSString*)value;




- (NSNumber*)primitiveInfant;
- (void)setPrimitiveInfant:(NSNumber*)value;

- (BOOL)primitiveInfantValue;
- (void)setPrimitiveInfantValue:(BOOL)value_;




- (NSNumber*)primitiveClassesCount;
- (void)setPrimitiveClassesCount:(NSNumber*)value;

- (int)primitiveClassesCountValue;
- (void)setPrimitiveClassesCountValue:(int)value_;




- (NSNumber*)primitiveParsed;
- (void)setPrimitiveParsed:(NSNumber*)value;

- (BOOL)primitiveParsedValue;
- (void)setPrimitiveParsedValue:(BOOL)value_;




- (NSString*)primitiveIndex;
- (void)setPrimitiveIndex:(NSString*)value;




- (NSNumber*)primitiveAu;
- (void)setPrimitiveAu:(NSNumber*)value;

- (short)primitiveAuValue;
- (void)setPrimitiveAuValue:(short)value_;




- (NSString*)primitiveCode;
- (void)setPrimitiveCode:(NSString*)value;




- (NSString*)primitiveStatus;
- (void)setPrimitiveStatus:(NSString*)value;





- (NSMutableSet*)primitiveClasses;
- (void)setPrimitiveClasses:(NSMutableSet*)value;



- (JONTUSemester*)primitiveSemester;
- (void)setPrimitiveSemester:(JONTUSemester*)value;



- (JONTUCourseDetails*)primitiveDetail;
- (void)setPrimitiveDetail:(JONTUCourseDetails*)value;


@end
