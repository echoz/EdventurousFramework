//
//  JONTUVideoStreamingServer.m
//  Edventurous
//
//  Created by Jeremy Foo on 10/7/10.
//  Copyright 2010 ORNYX. All rights reserved.
//

#import "JONTUVideoStreamingServer.h"
#import "RegexKitLite.h"

#define PARSE_REGEX_V4 @"addStreamInfo\\(\"([a-zA-Z0-9\\-]*)\",\\s*\"([0-9\\.]*)\",\\s*\"([0-9\\.]*)\",\\s*\"([0-9\\.]*)\",\\s*\"([0-9]*)\"\\);"
#define PRASE_REGEX_V7 @"addStreamInfo\\(\"([0-9a-zA-Z\\\\-]*)\",\"([0-9\\.]*)\",\"([0-9\\.]*)\",([0-9]*)\\);"

@implementation JONTUVideoStreamingServer
@synthesize name, IISHost, WMSHost, gatewayHost, gatewayPort, timeout;

-(id)initFromPage:(NSData *)html {
	if (self = [super init]) {
		
	}
	return self;
}

-(void)dealloc {
	[name release], name = nil;
	[IISHost release], IISHost = nil;
	[WMSHost release], WMSHost = nil;
	[gatewayHost release], gatewayHost = nil;
	[super dealloc];
}
@end
