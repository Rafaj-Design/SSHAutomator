//
//  RIJobsController.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RIAccount, RIJob;

@interface RIJobsController : NSObject <UITableViewDataSource>

@property (nonatomic, copy) void (^requiresReload)();
@property (nonatomic, strong) RIAccount *account;

- (RIJob *)jobAtIndexPath:(NSIndexPath *)indexPath;

- (void)reloadData;


@end
