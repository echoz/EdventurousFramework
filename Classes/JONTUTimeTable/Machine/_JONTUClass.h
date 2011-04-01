// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to JONTUClass.h instead.

#import <CoreData/CoreData.h>
#import "JONTUTimeTable.h"

@class JONTUCourse;








@interface JONTUClassID : NSManagedObjectID {}
@end

@interface _JONTUClass : JONTUTimeTable {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (JONTUClassID*)objectID;



@property (nonatomic, retain) NSString *type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *venue;

//- (BOOL)validateVenue:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *group;

//- (BOOL)validateGroup:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *time;

//- (BOOL)validateTime:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *day;

//- (BOOL)validateDay:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *remark;

//- (BOOL)validateRemark:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) JONTUCourse* course;
//- (BOOL)validateCourse:(id*)value_ error:(NSError**)error_;




@end

@interface _JONTUClass (CoreDataGeneratedAccessors)

@end

@interface _JONTUClass (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;




- (NSString*)primitiveVenue;
- (void)setPrimitiveVenue:(NSString*)value;




- (NSString*)primitiveGroup;
- (void)setPrimitiveGroup:(NSString*)value;




- (NSString*)primitiveTime;
- (void)setPrimitiveTime:(NSString*)value;




- (NSString*)primitiveDay;
- (void)setPrimitiveDay:(NSString*)value;




- (NSString*)primitiveRemark;
- (void)setPrimitiveRemark:(NSString*)value;





- (JONTUCourse*)primitiveCourse;
- (void)setPrimitiveCourse:(JONTUCourse*)value;


@end
