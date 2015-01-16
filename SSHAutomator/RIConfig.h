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
+ (UIColor *)backgroundColor;
+ (UIColor *)borderColor;
+ (UIColor *)dangerColor;


@end
