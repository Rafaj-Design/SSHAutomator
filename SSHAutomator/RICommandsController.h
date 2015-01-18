//
//  RICommandsController.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 18/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RICommandsController : NSObject <UITableViewDataSource>

@property (nonatomic, copy) void (^requiresReload)();


- (NSArray *)commandAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)commands;

- (void)reloadData;


@end
