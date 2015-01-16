//
//  RIAccountsController.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RIAccount;

@interface RIAccountsController : NSObject <UITableViewDataSource>

@property (nonatomic, copy) void (^requiresReload)();

- (RIAccount *)accountAtIndexPath:(NSIndexPath *)indexPath;

- (void)reloadData;


@end
