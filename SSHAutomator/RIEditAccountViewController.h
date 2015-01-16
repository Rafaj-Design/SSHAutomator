//
//  RIEditAccountViewController.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RITableViewController.h"


@class RIAccount;

@interface RIEditAccountViewController : RITableViewController

@property (nonatomic, copy) void (^dismissController)(RIEditAccountViewController *controller, RIAccount *account);
@property (nonatomic, strong) RIAccount *account;


@end
