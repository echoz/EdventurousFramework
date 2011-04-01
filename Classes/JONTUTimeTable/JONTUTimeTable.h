//
//  JONTUTimeTable.h
//  Edventurous
//
//  Created by Jeremy Foo on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObjectContextAdditions.h"

typedef enum {
	JONTUTimeTableReplaceLocalPolicy = 1,
	JONTUTimeTableReplaceRemotePolicy = 2
} JONTUTimeTableSyncPolicy;

@interface JONTUTimeTable : NSManagedObject {
    
}

-(void)syncWithPolicy:(JONTUTimeTableSyncPolicy)policy;

@end
