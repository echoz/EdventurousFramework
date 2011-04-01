#import "_JONTUCourseDetails.h"

@interface JONTUCourseDetails : _JONTUCourseDetails {}
+(JONTUCourseDetails *)courseWithCode:(NSString *)code semester:(JONTUSemester *)semester managedContext:(NSManagedObjectContext *)moc;
@end
