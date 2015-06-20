//
//  RITableViewCell.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RITableViewCell.h"
#import "RIConfig.h"


@implementation RITableViewCell


#pragma mark Creating elements

- (void)createAllElements {
    
}

#pragma mark Initialization

- (void)setup {
    [self.textLabel setTextColor:[RIConfig textColor]];
    [self setBackgroundColor:[RIConfig tableBackgroundColor]];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
        [self createAllElements];
    }
    return self;
}


@end
