//
//  RIBrowserTableViewCell.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 21/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIBrowserTableViewCell.h"


@implementation RIBrowserTableViewCell


#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
}

- (void)setFileSelected:(BOOL)fileSelected {
    _fileSelected = fileSelected;
    [self setAccessoryType:(_fileSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone)];
}

#pragma mark Initialization

- (void)setup {
    [super setup];
    
    [self.detailTextLabel setTextColor:[UIColor grayColor]];
    [self.detailTextLabel setLineBreakMode:NSLineBreakByTruncatingHead];
}


@end
