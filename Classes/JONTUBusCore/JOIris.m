//
//  JOIris.m
//  Edventurous
//
//  Created by Jeremy Foo on 11/12/10.
//  Copyright 2010 ORNYX. All rights reserved.
//

#import "JOIris.h"
#import "RegexKitLite.h"

#define IRISURL @"http://www.sbstransit.com.sg/mobileiris/"
#define IRISSTOP @"index_svclist.aspx?stopcode=%@"
#define IRISARRIVAL @"index_mobresult.aspx?stop=%@&svc=%@"

#define REGEX_STOPDETAILS @"<font size=\"-1\">(.*)<br>\s*(.*)</font><br>"
#define REGEX_BUSES @"<a href=\"index_mobresult.aspx?[^\"]*\">(.*)</a>"
#define REGEX_BUS @"<font size=\"-1\">Service (.*)<br>\s*Next bus: (.*)<br>\s*Subsequent bus: (.*)</font><br>"

@interface JOIris (PrivateMethods)
-(NSString *)escapeString:(NSString *) str;
-(NSData *) sendSyncXHRToURL:(NSURL *)url postValues:(NSDictionary *)postValues returningResponse:(NSHTTPURLResponse **) response error:(NSError **)error;
@end

@implementation JOIris (PrivateMethods)
-(NSString *)escapeString:(NSString *) str {
	return [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR(" ()<>#%{}|\\^~[]`;/?:@=&$"), kCFStringEncodingUTF8) autorelease];
}

-(NSData *) sendSyncXHRToURL:(NSURL *)url postValues:(NSDictionary *)postValues returningResponse:(NSHTTPURLResponse **) response error:(NSError **)error {
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	
	if (postValues) {
		NSMutableString *post = [NSMutableString string];	
		for (NSString *key in postValues) {
			if ([post length] > 0) {
				[post appendString:@"&"];
			}
			[post appendFormat:@"%@=%@",[self escapeString:key],[self escapeString:[postValues objectForKey:key]]];
		}
		
		NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
		NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
		[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
		[request setHTTPBody:postData];
		
		[request setHTTPMethod:@"POST"];
		[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		
	}
	
	NSData *recvData = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
	[request release];
	
	return recvData;
	
}
@end



@implementation JOIris

-(id)init {
	if (self = [super init]) {
		NSHTTPURLResponse *resp;
		NSError *err;
		NSArray *path = nil;
		
		if ([self sendSyncXHRToURL:[NSURL URLWithString:IRISURL] postValues:nil returningResponse:&resp error:&err]) {
			path = [[resp URL] pathComponents];
		
		}
		
		if ([path count] > 0) {
			if ([[[path lastObject] uppercaseString] hasPrefix:@"INDEX"]) {
				hash = [[path objectAtIndex:([path count]-2)] retain];
			} else {
				hash = [[path lastObject] retain];
			}
		}
	}
	return self;
}

-(NSArray *)arrivalsForService:(NSString *)serviceNumber atBusStop:(NSString *)buscode {
	
}

-(NSDictionary *)busesAtBusStop:(NSString *)buscode {
	// return street address and friendly name as first 2 entries of arrivals	
}

-(void)dealloc {
	[hash release], hash = nil;
	
	[super dealloc];
}


	
@end
