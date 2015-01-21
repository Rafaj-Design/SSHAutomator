//
//  RITableViewCell.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RITableViewCell.h"


@implementation RITableViewCell


#pragma mark Creating elements

- (void)createAllElements {
    
}

#pragma mark Initialization

- (void)setup {
    
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
