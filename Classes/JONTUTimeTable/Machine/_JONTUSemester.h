// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JONTUSemester.h instead.

#import <CoreData/CoreData.h>
#import "JOManagedObject.h"

@class JONTUCourseDetails;
@class JONTUCourse;











@interface JONTUSemesterID : NSManagedObjectID {}
@end

@interface _JONTUSemester : JOManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (JONTUSemesterID*)objectID;



@property (nonatomic, retain) NSDate *birthDate;

//- (BOOL)validateBirthDate:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *lastAccessed;

//- (BOOL)validateLastAccessed:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *infant;

@property BOOL infantValue;
- (BOOL)infantValue;
- (void)setInfantValue:(BOOL)value_;

//- (BOOL)validateInfant:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *coursesCount;

@property long long coursesCountValue;
- (long long)coursesCountValue;
- (void)setCoursesCountValue:(long long)value_;

//- (BOOL)validateCoursesCount:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *year;

@property long long yearValue;
- (long long)yearValue;
- (void)setYearValue:(long long)value_;

//- (BOOL)validateYear:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *parsed;

@property BOOL parsedValue;
- (BOOL)parsedValue;
- (void)setParsedValue:(BOOL)value_;

//- (BOOL)validateParsed:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *semester;

//- (BOOL)validateSemester:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *lastParsed;

//- (BOOL)validateLastParsed:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* courseDetails;
- (NSMutableSet*)courseDetailsSet;



@property (nonatomic, retain) NSSet* courses;
- (NSMutableSet*)coursesSet;




@end

@interface _JONTUSemester (CoreDataGeneratedAccessors)

- (void)addCourseDetails:(NSSet*)value_;
- (void)removeCourseDetails:(NSSet*)value_;
- (void)addCourseDetailsObject:(JONTUCourseDetails*)value_;
- (void)removeCourseDetailsObject:(JONTUCourseDetails*)value_;

- (void)addCourses:(NSSet*)value_;
- (void)removeCourses:(NSSet*)value_;
- (void)addCoursesObject:(JONTUCourse*)value_;
- (void)removeCoursesObject:(JONTUCourse*)value_;

@end

@interface _JONTUSemester (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveBirthDate;
- (void)setPrimitiveBirthDate:(NSDate*)value;




- (NSDate*)primitiveLastAccessed;
- (void)setPrimitiveLastAccessed:(NSDate*)value;




- (NSNumber*)primitiveInfant;
- (void)setPrimitiveInfant:(NSNumber*)value;

- (BOOL)primitiveInfantValue;
- (void)setPrimitiveInfantValue:(BOOL)value_;




- (NSNumber*)primitiveCoursesCount;
- (void)setPrimitiveCoursesCount:(NSNumber*)value;

- (long long)primitiveCoursesCountValue;
- (void)setPrimitiveCoursesCountValue:(long long)value_;




- (NSNumber*)primitiveYear;
- (void)setPrimitiveYear:(NSNumber*)value;

- (long long)primitiveYearValue;
- (void)setPrimitiveYearValue:(long long)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveParsed;
- (void)setPrimitiveParsed:(NSNumber*)value;

- (BOOL)primitiveParsedValue;
- (void)setPrimitiveParsedValue:(BOOL)value_;




- (NSString*)primitiveSemester;
- (void)setPrimitiveSemester:(NSString*)value;




- (NSDate*)primitiveLastParsed;
- (void)setPrimitiveLastParsed:(NSDate*)value;





- (NSMutableSet*)primitiveCourseDetails;
- (void)setPrimitiveCourseDetails:(NSMutableSet*)value;



- (NSMutableSet*)primitiveCourses;
- (void)setPrimitiveCourses:(NSMutableSet*)value;


@end
