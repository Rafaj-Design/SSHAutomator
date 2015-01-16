//
//  RIConfig.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIConfig.h"


@implementation RIConfig


#pragma mark Fonts

+ (UIFont *)systemFontOfSize:(CGFloat)size {
    return [UIFont systemFontOfSize:size];
}

#pragma mark Colors

+ (UIColor *)mainColor {
    return [UIColor colorWithRed:(32.0f / 255.0f) green:(131.0f / 255.0f) blue:(203.0f / 255.0f) alpha:1];
}

+ (UIColor *)lightMainColor {
    return [UIColor colorWithRed:(74.0f / 255.0f) green:(166.0f / 255.0f) blue:(230.0f / 255.0f) alpha:1];
}

+ (UIColor *)textColor {
    return [UIColor darkGrayColor];
}

+ (UIColor *)lightTextColor {
    return [UIColor whiteColor];
}

+ (UIColor *)backgroundColor {
    return [UIColor colorWithRed:(241.0f / 255.0f) green:(241.0f / 255.0f) blue:(241.0f / 255.0f) alpha:1];
}

+ (UIColor *)borderColor {
    return [UIColor colorWithWhite:0 alpha:0.04];
}

+ (UIColor *)dangerColor {
    return [UIColor colorWithRed:(235.0f / 255.0f) green:(70.0f / 255.0f) blue:(50.0f / 255.0f) alpha:1];
}


@end
