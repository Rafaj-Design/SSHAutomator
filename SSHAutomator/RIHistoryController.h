//
//  RIHistoryController.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 18/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RIJob, RIHistory;

@interface RIHistoryController : NSObject <UITableViewDataSource>

@property (nonatomic, copy) void (^requiresReload)();
@property (nonatomic, strong) RIJob *job;


- (RIHistory *)historyAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)history;

- (void)clearHistory;

- (void)reloadData;


@end
