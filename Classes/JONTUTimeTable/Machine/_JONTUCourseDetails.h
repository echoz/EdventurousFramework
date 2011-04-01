// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JONTUCourseDetails.h instead.

#import <CoreData/CoreData.h>
#import "JOManagedObject.h"

@class JONTUSemester;
@class JONTUCourse;
















@interface JONTUCourseDetailsID : NSManagedObjectID {}
@end

@interface _JONTUCourseDetails : JOManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (JONTUCourseDetailsID*)objectID;



@property (nonatomic, retain) NSDate *lastParsed;

//- (BOOL)validateLastParsed:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *notAvailUE;

//- (BOOL)validateNotAvailUE:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *prereq;

//- (BOOL)validatePrereq:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *birthDate;

//- (BOOL)validateBirthDate:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *lastAccessed;

//- (BOOL)validateLastAccessed:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *notAvailCORE;

//- (BOOL)validateNotAvailCORE:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *infant;

@property BOOL infantValue;
- (BOOL)infantValue;
- (void)setInfantValue:(BOOL)value_;

//- (BOOL)validateInfant:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *mutex;

//- (BOOL)validateMutex:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *parsed;

@property BOOL parsedValue;
- (BOOL)parsedValue;
- (void)setParsedValue:(BOOL)value_;

//- (BOOL)validateParsed:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *notAvailPE;

//- (BOOL)validateNotAvailPE:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *details;

//- (BOOL)validateDetails:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *code;

//- (BOOL)validateCode:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *runBy;

//- (BOOL)validateRunBy:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) JONTUSemester* semester;
//- (BOOL)validateSemester:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSSet* courses;
- (NSMutableSet*)coursesSet;




@end

@interface _JONTUCourseDetails (CoreDataGeneratedAccessors)

- (void)addCourses:(NSSet*)value_;
- (void)removeCourses:(NSSet*)value_;
- (void)addCoursesObject:(JONTUCourse*)value_;
- (void)removeCoursesObject:(JONTUCourse*)value_;

@end

@interface _JONTUCourseDetails (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveLastParsed;
- (void)setPrimitiveLastParsed:(NSDate*)value;




- (NSString*)primitiveNotAvailUE;
- (void)setPrimitiveNotAvailUE:(NSString*)value;




- (NSString*)primitivePrereq;
- (void)setPrimitivePrereq:(NSString*)value;




- (NSDate*)primitiveBirthDate;
- (void)setPrimitiveBirthDate:(NSDate*)value;




- (NSDate*)primitiveLastAccessed;
- (void)setPrimitiveLastAccessed:(NSDate*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSString*)primitiveNotAvailCORE;
- (void)setPrimitiveNotAvailCORE:(NSString*)value;




- (NSNumber*)primitiveInfant;
- (void)setPrimitiveInfant:(NSNumber*)value;

- (BOOL)primitiveInfantValue;
- (void)setPrimitiveInfantValue:(BOOL)value_;




- (NSString*)primitiveMutex;
- (void)setPrimitiveMutex:(NSString*)value;




- (NSNumber*)primitiveParsed;
- (void)setPrimitiveParsed:(NSNumber*)value;

- (BOOL)primitiveParsedValue;
- (void)setPrimitiveParsedValue:(BOOL)value_;




- (NSString*)primitiveNotAvailPE;
- (void)setPrimitiveNotAvailPE:(NSString*)value;




- (NSString*)primitiveDetails;
- (void)setPrimitiveDetails:(NSString*)value;




- (NSString*)primitiveCode;
- (void)setPrimitiveCode:(NSString*)value;




- (NSString*)primitiveRunBy;
- (void)setPrimitiveRunBy:(NSString*)value;





- (JONTUSemester*)primitiveSemester;
- (void)setPrimitiveSemester:(JONTUSemester*)value;



- (NSMutableSet*)primitiveCourses;
- (void)setPrimitiveCourses:(NSMutableSet*)value;


@end
