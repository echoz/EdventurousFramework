//
//  JONTULocation.m
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
#import "JONTULocation.h"
#import "JSON.h"


#define SEARCH_URL @"http://maps.ntu.edu.sg/a/search?q="

@implementation JONTULocation
@synthesize latlng, locID, type, name, category, unit_number, url, floor_plan, parsed;

+(id)search:(NSString *)searchStr {
	JONTUAuth *xhr = [[JONTUAuth alloc] init];
	xhr.user = @"";
	xhr.pass = @"";
	xhr.domain = @"";
	
	[xhr release];
	
	return nil;
}

-(id)initWithLocation:(NSString *)loc lazy:(BOOL)lazy {
	if ((self = [super init])) {
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
	return nil;
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
		bUID = [[locationDetails objectForKey:@"uid"] retain];
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
	[type release], type = nil;
	[name release], name = nil;
	[category release], category = nil;
	[unit_number release], unit_number = nil;
	[url release], url = nil;
	[floor_plan release], floor_plan = nil;
	[super dealloc];
}


@end
