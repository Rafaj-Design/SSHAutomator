//
//  RIAccountsTableView.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIAccountsTableView.h"


@implementation RIAccountsTableView


#pragma mark Settings

- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    [super setDataSource:dataSource];
    _controller = (id)dataSource;
}


@end
