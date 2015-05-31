//
//  RIHistoryViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 18/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIHistoryViewController.h"
#import <LUIFramework/LUIFramework.h>
#import "RIConsoleViewController.h"
#import "RIHistoryController.h"
#import "RITableView.h"


@interface RIHistoryViewController () <UITableViewDelegate>

@property (nonatomic, readonly) RIHistoryController *controller;
@property (nonatomic, readonly) RITableView *tableView;

@end


@implementation RIHistoryViewController


#pragma mark Creating elements

- (void)createClearButton {
    UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearHistory:)];
    [self.navigationItem setRightBarButtonItem:clear];
}

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
    [self createClearButton];
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

- (void)clearHistory:(UIBarButtonItem *)sender {
    [_controller clearHistory];
    [self reloadData];
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(pop) userInfo:nil repeats:NO];
}

#pragma mark Navigation

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Initialization

- (void)setup {
    [super setup];
    
    [self setTitle:LUITranslate(@"History")];
    
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
