//
//  JOManagedObject.m
//  Edventurous
//
//  Created by Jeremy Foo on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JOManagedObject.h"


@implementation JOManagedObject

#pragma mark -
#pragma mark NSManagedObject lifecycle

-(void)didTurnIntoFault {
	[self stopSync];
	[super didTurnIntoFault];
}

#pragma mark -
#pragma mark Syncing

-(void)stopSync {
	[__request cancel];
	[__request release], __request = nil;
}

-(BOOL)syncWithPolicy:(JOManagedObjectSyncPolicy)policy {
	[NSException raise:NSInternalInconsistencyException
				format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return NO;
}

@end
