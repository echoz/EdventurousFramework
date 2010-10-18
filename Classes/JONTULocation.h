//
//  JONTULocation.h
//  Edventurous
//
//  Created by Jeremy Foo on 10/15/10.
//
//  The MIT License
//  
//  Copyright (c) 2010 Jeremy Foo
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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
// or return single JONTULocation autoreleased object if search string is exact.
+(id)search:(NSString *)searchStr; 


@end
