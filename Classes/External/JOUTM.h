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
	double utm_x;
	double utm_y;
	int utm_zone;
	BOOL utm_southHemi;
	double latitude;
	double longitude;
}
@property (readonly) double utm_x;
@property (readonly) double utm_y;
@property (readonly) double latitude;
@property (readonly) double longitude;
@property (readonly) int utm_zone;
@property (readonly) BOOL utm_southHemi;

-(CLLocation *)location;
-(CLLocationCoordinate2D)coordinate;

-(id)initWithLatitude:(double)lat Longtitude:(double)lon;
-(id)initWithLocation:(CLLocation *)location;
-(id)initWithX:(double)x Y:(double)y zone:(int)zone SouthHemisphere:(BOOL)southhemi;


@end
