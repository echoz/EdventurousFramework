//
//  JOIris.h
//  Edventurous
//
//  Created by Jeremy Foo on 11/12/10.
//  Copyright 2010 ORNYX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JOIris : NSObject {
	NSString *hash;
}
-(NSArray *)arrivalsForService:(NSString *)serviceNumber atBusStop:(NSString *)buscode;
-(NSDictionary *)busesAtBusStop:(NSString *)buscode;

@end
