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
    return [UIColor colorWithRed:(100.0f / 255.0f) green:(161.0f / 255.0f) blue:(13.0f / 255.0f) alpha:1];
}

+ (UIColor *)lightMainColor {
    return [UIColor colorWithRed:(154.0f / 255.0f) green:(208.0f / 255.0f) blue:(156.0f / 255.0f) alpha:1];
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
    return [UIColor colorWithRed:(254.0f / 255.0f) green:(205.0f / 255.0f) blue:(190.0f / 255.0f) alpha:1];
}


@end
