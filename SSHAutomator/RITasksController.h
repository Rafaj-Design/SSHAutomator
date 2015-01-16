//
//  RITasksController.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RIJob, RITask;

@interface RITasksController : NSObject <UITableViewDataSource>

@property (nonatomic, copy) void (^requiresReload)();
@property (nonatomic, strong) RIJob *job;

- (RITask *)taskAtIndexPath:(NSIndexPath *)indexPath;

- (void)reloadData;
- (void)saveOrder;


@end
