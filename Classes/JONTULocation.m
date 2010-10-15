//
//  JONTULocation.m
//  Edventurous
//
//  Created by Jeremy Foo on 10/15/10.
//  Copyright 2010 ORNYX. All rights reserved.
//

#import "JONTULocation.h"
#import "JSON.h"


#define SEARCH_URL @"http://maps.ntu.edu.sg/a/search?q="

@implementation JONTULocation
@synthesize latlng, locID, uid, type, name, category, unit_number, url, floor_plan, parsed;

+(NSArray *)search:(NSString *)searchStr {
	JONTUAuth *xhr = [[JONTUAuth alloc] init];
	xhr.user = @"";
	xhr.pass = @"";
	xhr.domain = @"";
	
	return nil;
}

-(id)initWithLocation:(NSString *)loc lazy:(BOOL)lazy {
	if (self = [super init]) {
		self.user = @"";
		self.pass = @"";
		self.domain = @"";
		
		parsed = NO;
		
		name = [loc retain];
		if (!lazy) {
			if (![self parse]) {
				return nil;
			}
		}
	}
	return self;
}

-(id)initWithJSON:(NSData *)jsonData {
	
}

-(BOOL)parse {

	// parsed before, too bad.
	if (parsed)
		return parsed;
	
	NSData *results = [self sendSyncXHRToURL:[NSURL URLWithString:[SEARCH_URL stringByAppendingString:[self escapeString:self.name]]]
								  postValues:nil
								   withToken:NO];
	
	NSString *resultsStr = [[NSString alloc] initWithData:results encoding:NSUTF8StringEncoding];
	NSDictionary *resultsDict = [resultsStr JSONValue];
	[resultsStr release];
	
	if ([[[resultsDict objectForKey:@"type"] lowercaseString] isEqualToString:@"LOCATION"]) {
		NSDictionary *locationDetails = [[[resultsDict objectForKey:@"what"] objectForKey:@"businesses"] objectAtIndex:0];
		
		name = [[locationDetails objectForKey:@"name"] retain];
		floor_plan = [[[locationDetails objectForKey:@"more_info"] objectForKey:@"floorplan"] retain];
		type = [[locationDetails objectForKey:@"BUSINESS"] retain];
		uid = [[locationDetails objectForKey:@"uid"] retain];
		unit_number = [[locationDetails objectForKey:@"unit_number"] retain];
		locID = [[locationDetails objectForKey:@"id"] retain];
		
		parsed = YES;
		
	} else {
		parsed = NO;
	}	
	
	return parsed;
}

-(void)dealloc {
	[locID release], locID = nil;
	[uid release], uid = nil;
	[type release], type = nil;
	[name release], name = nil;
	[category release], category = nil;
	[unit_number release], unit_number = nil;
	[url release], url = nil;
	[floor_plan release], floor_plan = nil;
	[super dealloc];
}


@end
