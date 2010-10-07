//
//  JONTUVideoStreamingServer.h
//  Edventurous
//
//  Created by Jeremy Foo on 10/7/10.
//  Copyright 2010 ORNYX. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JONTUVideoStreamingServer : NSObject {
	NSString *name;
	NSString *IISHost;
	NSString *WMSHost;
	NSString *gatewayHost;
	NSUInteger gatewayPort;
	NSUInteger timeout;
}

@property (readonly) NSString *name;
@property (readonly) NSString *IISHost;
@property (readonly) NSString *WMSHost;
@property (readonly) NSString *gatewayHost;
@property (readonly) NSUInteger gatewayPort;
@property (readonly) NSUInteger timeout;

-(id)initFromPage:(NSData *)html;

@end
