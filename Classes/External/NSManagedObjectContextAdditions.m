//
//  NSManagedObjectContextAdditions.m
//  lbciphone
//
//  Created by Jeremy Foo on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObjectContextAdditions.h"


@implementation NSManagedObjectContext (NSManagedObjectContextAdditions)

// Convenience method to fetch the array of objects for a given Entity
// name in the context, optionally limiting by a predicate or by a predicate
// made from a format NSString and variable arguments.
//
- (NSSet *)fetchObjectsForEntityName:(NSString *)newEntityName
					   withPredicate:(id)stringOrPredicate, ...
{
    NSEntityDescription *entity = [NSEntityDescription
								   entityForName:newEntityName inManagedObjectContext:self];
	
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entity];
    
    if (stringOrPredicate)
    {
        NSPredicate *predicate;
        if ([stringOrPredicate isKindOfClass:[NSString class]])
        {
            va_list variadicArguments;
            va_start(variadicArguments, stringOrPredicate);
            predicate = [NSPredicate predicateWithFormat:stringOrPredicate
											   arguments:variadicArguments];
            va_end(variadicArguments);
        }
        else
        {
            NSAssert2([stringOrPredicate isKindOfClass:[NSPredicate class]],
					  @"Second parameter passed to %s is of unexpected class %@",
					  sel_getName(_cmd), NSStringFromClass([stringOrPredicate class]));
            predicate = (NSPredicate *)stringOrPredicate;
        }
        [request setPredicate:predicate];
    }
	
    NSError *error = nil;
    NSArray *results = [self executeFetchRequest:request error:&error];
    if (error != nil)
    {
        [NSException raise:NSGenericException format:[error description], nil];
    }
    
    return [NSSet setWithArray:results];
}

@end
