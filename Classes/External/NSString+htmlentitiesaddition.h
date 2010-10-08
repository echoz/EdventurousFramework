//
//  NSString+htmlentitiesaddition.h
//  RushHourNTU
//
//  Created by Jeremy Foo on 4/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#if (TARGET_OS_IPHONE||TARGET_IPHONE_SIMULATOR)
#import <UIKit/UIKit.h>
#endif

@interface NSString (JOHTMLEntitiesAddition)
-(NSString *)removeHTMLEntities;

#if (TARGET_OS_IPHONE||TARGET_IPHONE_SIMULATOR)
-(UIColor *) UIColorValue;
#endif
@end
