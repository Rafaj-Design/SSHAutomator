//
//  RIBrowserViewController.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 20/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RITableViewController.h"


@class RIAccount;

@interface RIBrowserViewController : RITableViewController

@property (nonatomic, copy) void (^insertPath)(NSString *path);

@property (nonatomic, strong) RIAccount *account;


@end
