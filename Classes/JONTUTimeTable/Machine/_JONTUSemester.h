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



@property (nonatomic, retain) NSNumber *year;

@property long long yearValue;
- (long long)yearValue;
- (void)setYearValue:(long long)value_;

//- (BOOL)validateYear:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *semester;

//- (BOOL)validateSemester:(id*)value_ error:(NSError**)error_;




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


- (NSNumber*)primitiveYear;
- (void)setPrimitiveYear:(NSNumber*)value;

- (long long)primitiveYearValue;
- (void)setPrimitiveYearValue:(long long)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveSemester;
- (void)setPrimitiveSemester:(NSString*)value;





- (NSMutableSet*)primitiveCourseDetails;
- (void)setPrimitiveCourseDetails:(NSMutableSet*)value;



- (NSMutableSet*)primitiveCourses;
- (void)setPrimitiveCourses:(NSMutableSet*)value;


@end
