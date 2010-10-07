//
//  JOUTM.h
//  Edventurous
//
//  Created by Jeremy Foo on 10/7/10.
//  Copyright 2010 ORNYX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface JOUTM : NSObject {
	float utm_x;
	float utm_y;
	int utm_zone;
	BOOL utm_southHemi;
	float latitude;
	float longitude;
}
@property (readonly) float utm_x;
@property (readonly) float utm_y;
@property (readonly) float latitude;
@property (readonly) float longitude;
@property (readonly) int utm_zone;
@property (readonly) BOOL utm_southHemi;

-(CLLocation *)location;
-(CLLocationCoordinate2D)coordinate;

-(id)initWithLatitude:(float)lat Longtitude:(float)lon;
-(id)initWithLocation:(CLLocation *)location;
-(id)initWithX:(float)x Y:(float)y zone:(int)zone SouthHemisphere:(BOOL)southhemi;


@end
