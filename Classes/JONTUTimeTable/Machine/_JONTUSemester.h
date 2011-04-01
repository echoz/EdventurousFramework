// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JONTUSemester.h instead.

#import <CoreData/CoreData.h>


@class JONTUCourse;





@interface JONTUSemesterID : NSManagedObjectID {}
@end

@interface _JONTUSemester : NSManagedObject {}
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




@property (nonatomic, retain) JONTUCourse* courses;
//- (BOOL)validateCourses:(id*)value_ error:(NSError**)error_;




@end

@interface _JONTUSemester (CoreDataGeneratedAccessors)

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





- (JONTUCourse*)primitiveCourses;
- (void)setPrimitiveCourses:(JONTUCourse*)value;


@end
