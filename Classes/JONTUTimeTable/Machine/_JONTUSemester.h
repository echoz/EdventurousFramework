// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JONTUSemester.h instead.

#import <CoreData/CoreData.h>
#import "JONTUTimeTable.h"

@class JONTUCourseDetails;
@class JONTUCourse;





@interface JONTUSemesterID : NSManagedObjectID {}
@end

@interface _JONTUSemester : JONTUTimeTable {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (JONTUSemesterID*)objectID;



@property (nonatomic, retain) NSString *year;

//- (BOOL)validateYear:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *semester;

@property int semesterValue;
- (int)semesterValue;
- (void)setSemesterValue:(int)value_;

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


- (NSString*)primitiveYear;
- (void)setPrimitiveYear:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveSemester;
- (void)setPrimitiveSemester:(NSNumber*)value;

- (int)primitiveSemesterValue;
- (void)setPrimitiveSemesterValue:(int)value_;





- (NSMutableSet*)primitiveCourseDetails;
- (void)setPrimitiveCourseDetails:(NSMutableSet*)value;



- (NSMutableSet*)primitiveCourses;
- (void)setPrimitiveCourses:(NSMutableSet*)value;


@end
