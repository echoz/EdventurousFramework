#import "_JONTUCourse.h"

@interface JONTUCourse : _JONTUCourse {}

+(JONTUCourse *)courseWithCode:(NSString *)code forSemester:(JONTUSemester *)semester managedContext:(NSManagedObjectContext *)moc;

@end
