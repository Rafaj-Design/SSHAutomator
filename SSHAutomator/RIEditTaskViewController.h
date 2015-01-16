//
//  RIEditTaskViewController.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RITableViewController.h"


@class RIJob, RITask;

@interface RIEditTaskViewController : RITableViewController

@property (nonatomic, copy) void (^dismissController)(RIEditTaskViewController *controller, RITask *task);

@property (nonatomic, strong) RIJob *job;
@property (nonatomic, strong) RITask *task;


@end
