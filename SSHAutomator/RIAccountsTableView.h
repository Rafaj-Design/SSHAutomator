//
//  RIAccountsTableView.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RITableView.h"


@class RIAccountsController;

@interface RIAccountsTableView : RITableView

@property (nonatomic, readonly) RIAccountsController *controller;


@end
