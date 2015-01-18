//
//  RIConsoleViewController.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIViewController.h"


@class RIJob, RIHistory;

@interface RIConsoleViewController : RIViewController

@property (nonatomic, strong) RIHistory *history;

- (void)executeJob:(RIJob *)job;


@end
