//
//  JONTUBusStop.m
//  NTUBusArrival
//
//  Created by Jeremy Foo on 3/24/10.
//  Copyright 2010 THIRDLY. All rights reserved.
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

#import "JONTUBusStop.h"
#import "JONTUBusEngine.h"
#import "RegexKitLite.h"

@implementation JONTUBusStop

static NSString *getEta = @"http://campusbus.ntu.edu.sg/ntubus/index.php/xml/getEta";
static NSString *irisQuery = @"http://www.sbstransit.com.sg/mobileiris/(dgqpm3555wxvql55dpcezqnm)/index_mobresult.aspx?stop=%@&svc=%@";
static NSString *irisRegex = @"Service (.*)\\s*Next bus:\\s*(.*)\\s*Subsequent bus:\\s*(.*)\\s*";

@synthesize busstopid, code, desc, roadName, lon, lat, otherBus;
@synthesize routes;

-(id)initWithID:(NSUInteger)stopID code:(NSString *)stopCode description:(NSString *)stopDesc roadName:(NSString *)stopRdName longtitude:(NSNumber *)stopLong latitude:(NSNumber *)stopLat otherBuses:(NSArray *)stopOtherBus {
	if (self = [super init]) {
		busstopid = stopID;
		code = [stopCode copy];
		desc = [stopDesc copy];
		roadName = [stopRdName copy];
		lon = [stopLong copy];
		lat = [stopLat copy];
		otherBus = [stopOtherBus copy];
		arrivals = nil;
		routes = [[NSMutableArray arrayWithCapacity:0] retain];
	}
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super init]) {
		busstopid = [aDecoder decodeIntegerForKey:@"stopID"];
		code = [[aDecoder decodeObjectForKey:@"code"] retain];
		desc = [[aDecoder decodeObjectForKey:@"desc"] retain];
		roadName = [[aDecoder decodeObjectForKey:@"roadName"] retain];
		lon = [[aDecoder decodeObjectForKey:@"lon"] retain];
		lat = [[aDecoder decodeObjectForKey:@"lat"] retain];
		otherBus = [[aDecoder decodeObjectForKey:@"otherBus"] retain];
		arrivals = nil;
	}
	return self;
	
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	NSLog(@"Encoding bus stop object: %@", desc);	
	[aCoder encodeInteger:busstopid forKey:@"stopID"];
	[aCoder encodeObject:code forKey:@"code"];
	[aCoder encodeObject:desc forKey:@"desc"];
	[aCoder encodeObject:roadName forKey:@"roadName"];
	[aCoder encodeObject:lon forKey:@"lon"];
	[aCoder encodeObject:lat forKey:@"lat"];
	[aCoder encodeObject:otherBus forKey:@"otherBus"];
}


-(NSArray *) arrivals {
	// array of all buses arriving. buses are dictionaries stipulating order, plate number, eta, routeid, routename.
	currentRouteid = nil;
	currentRouteName = nil;
	[arrivals release];
	arrivals = [[NSMutableArray array] retain];
	
	JONTUBusEngine *engine = [JONTUBusEngine sharedJONTUBusEngine];
	
	NSMutableDictionary *post = [NSMutableDictionary dictionary];
	[post setValue:[self code] forKey:@"busstopcode"];
	[post setValue:[NSString stringWithFormat:@"%f", (float)arc4random()/10000000000] forKey:@"r"];
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[engine sendXHRToURL:getEta PostValues:post]];
	
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	
	[parser parse];
	[parser release];
	
	return arrivals;
}

-(NSDictionary *)irisQueryForService:(NSString *)serviceNumber {
	return [JONTUBusStop irisQueryForService:serviceNumber atStop:[self code]];
	
}

+(NSDictionary *)irisQueryForService:(NSString *)serviceNumber atStop:(NSString *)busstopcode {
	NSMutableDictionary *irisQueryReturn = [NSMutableDictionary dictionary];
	
	JONTUBusEngine *engine = [JONTUBusEngine sharedJONTUBusEngine];
	NSData *queryData = [engine sendXHRToURL:[NSString stringWithFormat:irisQuery,busstopcode, serviceNumber] PostValues:nil];
	NSString *matchString = [[[NSString alloc] initWithData:queryData encoding:NSASCIIStringEncoding] autorelease];	
	matchString = [matchString stringByReplacingOccurrencesOfString:@"<font size=\"-1\">" withString:@""];
	matchString = [matchString stringByReplacingOccurrencesOfString:@"</font>" withString:@""];
	matchString = [matchString stringByReplacingOccurrencesOfString:@"<br>" withString:@""];

	NSArray *busstops = [matchString arrayOfCaptureComponentsMatchedByRegex:irisRegex];

	NSArray *properties = nil;

	if ([busstops count] > 0) {
		if ([busstops count] > 1) {
			for (int i=0;i<[busstops count];i++) {
				if ([[[busstops objectAtIndex:i] objectAtIndex:1] isEqualToString:serviceNumber]) {
					properties = [busstops objectAtIndex:i];
					break;
				}
			}
		} else {
			properties = [busstops objectAtIndex:0];
		}
		
		[irisQueryReturn setValue:[[properties objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:@"service"];
		[irisQueryReturn setValue:[[properties objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:@"eta"];
		[irisQueryReturn setValue:[[properties objectAtIndex:3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:@"subsequent"];
		
	}
	
	
	return irisQueryReturn;
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
	if ([elementName isEqualToString:@"route"]) {
		currentRouteid = [attributeDict objectForKey:@"id"];
		currentRouteName = [attributeDict objectForKey:@"name"];
	}
	
	if ([elementName isEqualToString:@"bus"]) {
		NSMutableDictionary *bus = [NSMutableDictionary dictionary];

		if ([attributeDict objectForKey:@"err"]) {
			[bus setValue:[attributeDict objectForKey:@"err"] forKey:@"err"];
		} else {
			[bus setValue:[attributeDict objectForKey:@"order"] forKey:@"order"];
			[bus setValue:[attributeDict objectForKey:@"name"] forKey:@"plate"];
			[bus setValue:[attributeDict objectForKey:@"eta"] forKey:@"eta"];			
		}

		[bus setValue:currentRouteid forKey:@"routeid"];
		[bus setValue:currentRouteName forKey:@"routename"];
		[arrivals addObject:bus];
	}
}

-(void)dealloc {
	[code release];
	[desc release];
	[roadName release];
	[lon release];
	[lat release];
	[otherBus release];
	[routes release];
	[arrivals release];
	[currentRouteid release];
	[currentRouteName release];
	[super dealloc];
}

@end
