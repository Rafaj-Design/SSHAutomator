//
//  RIConfig.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RIConfig : NSObject


// Fonts
+ (UIFont *)systemFontOfSize:(CGFloat)size;

// Colors
+ (UIColor *)mainColor;
+ (UIColor *)lightMainColor;
+ (UIColor *)textColor;
+ (UIColor *)lightTextColor;
+ (UIColor *)infoTextColor;
+ (UIColor *)dangerColor;

+ (UIColor *)terminalBackgroundColor;
+ (UIColor *)terminalTextColor;

+ (UIColor *)tableBackgroundColor;
+ (UIColor *)tabBarInactiveColor;


@end
