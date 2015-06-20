//
//  RIConfig.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIConfig.h"
#import <LUIFramework/LUIFramework.h>


@implementation RIConfig


#pragma mark Fonts

+ (UIFont *)systemFontOfSize:(CGFloat)size {
    return [UIFont systemFontOfSize:size];
}

#pragma mark Colors

+ (UIColor *)mainColor {
    //return [UIColor colorWithRed:(100.0f / 255.0f) green:(161.0f / 255.0f) blue:(13.0f / 255.0f) alpha:1];
    return LUIColor(@"mainColor");
}

+ (UIColor *)lightMainColor {
    //return [UIColor colorWithRed:(154.0f / 255.0f) green:(208.0f / 255.0f) blue:(156.0f / 255.0f) alpha:1];
    return LUIColor(@"lightMainColor");
}

+ (UIColor *)textColor {
    //return [UIColor darkGrayColor];
    return LUIColor(@"textColor");
}

+ (UIColor *)lightTextColor {
    //return [UIColor whiteColor];
    return LUIColor(@"lightTextColor");
}

+ (UIColor *)infoTextColor {
    //return [UIColor lightGrayColor];
    return LUIColor(@"infoTextColor");
}

+ (UIColor *)dangerColor {
    //return [UIColor colorWithRed:(254.0f / 255.0f) green:(205.0f / 255.0f) blue:(190.0f / 255.0f) alpha:1];
    return LUIColor(@"dangerColor");
}

+ (UIColor *)terminalBackgroundColor {
    //return [UIColor blueColor];
    return LUIColor(@"terminalBackgroundColor");
}

+ (UIColor *)terminalTextColor {
    //return [UIColor redColor];
    return LUIColor(@"terminalTextColor");
}

+ (UIColor *)tableBackgroundColor {
    //return [UIColor whiteColor];
    return LUIColor(@"tableBackgroundColor");
}

+ (UIColor *)tabBarInactiveColor {
    //return [UIColor redColor];
    return LUIColor(@"tabBarInactiveColor");
}


@end
