#import "JONTUCourseDetails.h"

@implementation JONTUCourseDetails

+(JONTUCourseDetails *)courseWithCode:(NSString *)code semester:(JONTUSemester *)semester managedContext:(NSManagedObjectContext *)moc {
	NSSet *results = [moc fetchObjectsForEntityName:[JONTUCourseDetails entityName] withPredicate:@"(code == %@) AND (semester == %@)", code, semester];
	
	if ([results count] == 1) {
		return [results anyObject];
	} else {
		JONTUCourseDetails *coursedetails = [[JONTUCourseDetails alloc] initWithEntity:[NSEntityDescription entityForName:[JONTUCourseDetails entityName] inManagedObjectContext:moc]
												 insertIntoManagedObjectContext:moc];

		coursedetails.semester = semester;
		coursedetails.code = code;
		
		return coursedetails;
	}
}
@end
