//
//  JOManagedObject.h
//  Edventurous
//
//  Created by Jeremy Foo on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JOURLRequest.h"
#import "NSManagedObjectContextAdditions.h"

typedef enum {
	JOManagedObjectNotSyncingStatus = 0,
	JOManagedObjectSyncingStatus = 1,
	JOManagedObjectSyncErrorStatus = 100
} JOManagedObjectSyncStatus;

typedef enum {
	JOManagedObjectReplaceLocalPolicy = 1,
	JOManagedObjectReplaceRemotePolicy = 2
} JOManagedObjectSyncPolicy;

@interface JOManagedObject : NSManagedObject {
	JOManagedObjectSyncStatus __syncStats;
	JOURLRequest *__request;
}

-(void)stopSync;
-(BOOL)syncWithPolicy:(JOManagedObjectSyncPolicy)policy;

@end
