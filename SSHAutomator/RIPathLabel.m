//
//  RIPathLabel.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 21/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIPathLabel.h"
#import <FontAwesomeKit/FAKFontAwesome.h>
#import "RIConfig.h"


@implementation RIPathLabel


#pragma mark Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.05]];
        [self setTextColor:[RIConfig textColor]];
        [self setFont:[UIFont boldSystemFontOfSize:10]];
        [self setNumberOfLines:2];
        [self setLineBreakMode:NSLineBreakByTruncatingHead];
        
        FAKFontAwesome *icon = [FAKFontAwesome folderOIconWithSize:30];
        UIImage *img = [UIImage imageWithStackedIcons:@[icon] imageSize:CGSizeMake(30, 30)];
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 16, 16)];
        [iv setContentMode:UIViewContentModeScaleAspectFit];
        [iv setImage:img];
        [self addSubview:iv];
    }
    return self;
}

#pragma mark Drawing

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = UIEdgeInsetsMake(3, 40, 3, 30);
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}


@end
