//
//  NSString+htmlentitiesaddition.m
//  RushHourNTU
//
//  Created by Jeremy Foo on 4/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSString+htmlentitiesaddition.h"


@implementation NSString (JOHTMLEntitiesAddition)

#define HEXCOLOR(c) [UIColor colorWithRed:((c)&0xFF)/255.0 \
green:((c>>8)&0xFF)/255.0 \
blue:((c>>16)&0xFF)/255.0 \
alpha:1.0]

//alpha:((c>>24)&0xFF)/255.0]

-(NSString *)removeHTMLEntities {
    self = [self stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&" options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    self = [self stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    self = [self stringByReplacingOccurrencesOfString:@"&Agrave;" withString:@"À" options:NSLiteralSearch range:NSMakeRange(0, [self length])];
	self = [self stringByReplacingOccurrencesOfString:@"\u00A0" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [self length])];
	

	return self;
}

#if (TARGET_OS_IPHONE||TARGET_IPHONE_SIMULATOR)
-(UIColor *) UIColorValue {
	unsigned int colorValue;
	[[NSScanner scannerWithString:self] scanHexInt:&colorValue];
	return HEXCOLOR(colorValue);
}
#endif

@end
