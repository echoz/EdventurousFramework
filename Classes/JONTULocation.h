//
//  JONTULocation.h
//  Edventurous
//
//  Created by Jeremy Foo on 10/15/10.
//  Copyright 2010 ORNYX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "JONTUAuth.h"

@interface JONTULocation : JONTUAuth {
	BOOL parsed;
	// ammenties nearby demarcated by where array's "markers"
	NSArray *nearby;
	
	// related to location type
	CLLocationCoordinate2D latlng;
	NSString *locUID;
	NSString *locID;
	NSString *locType;
	NSArray *bounds;
	NSArray *viewport;
	NSString *formatted_address;
	NSDictionary *addressComponents;
	
	// related to business type
	NSString *bID;
	NSString *bUID;
	NSString *type;
	NSString *floor_plan;
	
	// meta
	NSString *name;
	NSString *category;
	NSString *unit_number;
	NSString *url;
}
@property (readonly) CLLocationCoordinate2D latlng;
@property (readonly) NSString *locID;
@property (readonly) NSString *uid;
@property (readonly) NSString *type;
@property (readonly) NSString *name;
@property (readonly) NSString *category;
@property (readonly) NSString *unit_number;
@property (readonly) NSString *url;
@property (readonly) NSString *floor_plan;
@property (readonly) BOOL parsed;

-(id)initWithJSON:(NSData *)jsonData;
-(id)initWithLocation:(NSString *)loc lazy:(BOOL)lazy;
-(BOOL)parse;
// query general search for list and create NSArray of JONTULocation objects with lazy loaded exact location
+(NSArray *)search:(NSString *)searchStr; 


@end
