//
//  RIEditJobViewController.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RITableViewController.h"


@class RIAccount, RIJob;

@interface RIEditJobViewController : RITableViewController

@property (nonatomic, copy) void (^dismissController)(RIEditJobViewController *controller, RIJob *job);

@property (nonatomic, strong) RIAccount *account;
@property (nonatomic, strong) RIJob *job;


@end
