// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JONTUCourseDetails.h instead.

#import <CoreData/CoreData.h>


@class JONTUSemester;
@class JONTUCourse;










@interface JONTUCourseDetailsID : NSManagedObjectID {}
@end

@interface _JONTUCourseDetails : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (JONTUCourseDetailsID*)objectID;



@property (nonatomic, retain) NSString *mutex;

//- (BOOL)validateMutex:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *prereq;

//- (BOOL)validatePrereq:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *notAvailCORE;

//- (BOOL)validateNotAvailCORE:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *runBy;

//- (BOOL)validateRunBy:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *notAvailPE;

//- (BOOL)validateNotAvailPE:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *details;

//- (BOOL)validateDetails:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *notAvailUE;

//- (BOOL)validateNotAvailUE:(id*)value_ error:(NSError**)error_;




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


- (NSString*)primitiveMutex;
- (void)setPrimitiveMutex:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSString*)primitivePrereq;
- (void)setPrimitivePrereq:(NSString*)value;




- (NSString*)primitiveNotAvailCORE;
- (void)setPrimitiveNotAvailCORE:(NSString*)value;




- (NSString*)primitiveRunBy;
- (void)setPrimitiveRunBy:(NSString*)value;




- (NSString*)primitiveNotAvailPE;
- (void)setPrimitiveNotAvailPE:(NSString*)value;




- (NSString*)primitiveDetails;
- (void)setPrimitiveDetails:(NSString*)value;




- (NSString*)primitiveNotAvailUE;
- (void)setPrimitiveNotAvailUE:(NSString*)value;





- (JONTUSemester*)primitiveSemester;
- (void)setPrimitiveSemester:(JONTUSemester*)value;



- (NSMutableSet*)primitiveCourses;
- (void)setPrimitiveCourses:(NSMutableSet*)value;


@end
