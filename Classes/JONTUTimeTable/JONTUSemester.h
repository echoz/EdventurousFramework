#import "_JONTUSemester.h"
#import "JONTUAuth.h"

@interface JONTUSemester : _JONTUSemester {
	JONTUAuth *__auth;
}

@property (nonatomic, retain) JONTUAuth *auth;

+(JOURLRequest *)semestersWithAuth:(JONTUAuth *)auth parseNow:(BOOL)parsenow managedContext:(NSManagedObjectContext *)moc;
+(JONTUSemester *)semesterWithYear:(NSInteger)year semester:(NSString *)sem managedContext:(NSManagedObjectContext *)moc;
-(void)parse;
-(NSUInteger)totalAU;

@end
