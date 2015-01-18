//
//  RIHistoryViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 18/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIHistoryViewController.h"
#import "RIConsoleViewController.h"
#import "RIHistoryController.h"
#import "RITableView.h"


@interface RIHistoryViewController () <UITableViewDelegate>

@property (nonatomic, readonly) RIHistoryController *controller;
@property (nonatomic, readonly) RITableView *tableView;

@end


@implementation RIHistoryViewController


#pragma mark Creating elements

- (void)createTableView {
    _tableView = [[RITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_tableView setDataSource:_controller];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTableView];
}

#pragma mark Settings

- (void)setJob:(RIJob *)job {
    _job = job;
    [_controller setJob:_job];
}

- (void)reloadData {
    [_controller reloadData];
    [_tableView reloadData];
}

#pragma mark Actions

#pragma mark Initialization

- (void)setup {
    [super setup];
    
    [self setTitle:@"History"];
    
    _controller = [[RIHistoryController alloc] init];
}

#pragma mark Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RIConsoleViewController *c = [[RIConsoleViewController alloc] init];
    [c setHistory:[_controller historyAtIndexPath:indexPath]];
    [self.navigationController pushViewController:c animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}


@end
