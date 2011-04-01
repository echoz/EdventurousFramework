// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JONTUCourse.h instead.

#import <CoreData/CoreData.h>
#import "JONTUCourseDetails.h"

@class JONTUClass;
@class JONTUSemester;










@interface JONTUCourseID : NSManagedObjectID {}
@end

@interface _JONTUCourse : JONTUCourseDetails {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (JONTUCourseID*)objectID;



@property (nonatomic, retain) NSString *status;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *gepre;

//- (BOOL)validateGepre:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *choice;

//- (BOOL)validateChoice:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *su;

//- (BOOL)validateSu:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *au;

@property short auValue;
- (short)auValue;
- (void)setAuValue:(short)value_;

//- (BOOL)validateAu:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *index;

//- (BOOL)validateIndex:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* classes;
- (NSMutableSet*)classesSet;



@property (nonatomic, retain) JONTUSemester* semester;
//- (BOOL)validateSemester:(id*)value_ error:(NSError**)error_;




@end

@interface _JONTUCourse (CoreDataGeneratedAccessors)

- (void)addClasses:(NSSet*)value_;
- (void)removeClasses:(NSSet*)value_;
- (void)addClassesObject:(JONTUClass*)value_;
- (void)removeClassesObject:(JONTUClass*)value_;

@end

@interface _JONTUCourse (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveStatus;
- (void)setPrimitiveStatus:(NSString*)value;




- (NSString*)primitiveGepre;
- (void)setPrimitiveGepre:(NSString*)value;




- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;




- (NSString*)primitiveChoice;
- (void)setPrimitiveChoice:(NSString*)value;




- (NSString*)primitiveSu;
- (void)setPrimitiveSu:(NSString*)value;




- (NSNumber*)primitiveAu;
- (void)setPrimitiveAu:(NSNumber*)value;

- (short)primitiveAuValue;
- (void)setPrimitiveAuValue:(short)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveIndex;
- (void)setPrimitiveIndex:(NSString*)value;





- (NSMutableSet*)primitiveClasses;
- (void)setPrimitiveClasses:(NSMutableSet*)value;



- (JONTUSemester*)primitiveSemester;
- (void)setPrimitiveSemester:(JONTUSemester*)value;


@end
