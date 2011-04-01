//
//  NSManagedObjectContextAdditions.h
//  lbciphone
//
//  Created by Jeremy Foo on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (NSManagedObjectContextAdditions)
- (NSSet *)fetchObjectsForEntityName:(NSString *)newEntityName withPredicate:(id)stringOrPredicate, ...;
@end
