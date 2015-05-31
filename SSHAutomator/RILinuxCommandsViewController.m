//
//  RICommandsViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 18/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RILinuxCommandsViewController.h"
#import <LUIFramework/LUIFramework.h>
#import "RICommandsController.h"
#import "RITableView.h"


@interface RILinuxCommandsViewController () <UITableViewDelegate>

@property (nonatomic, readonly) RICommandsController *controller;
@property (nonatomic, readonly) RITableView *tableView;

@end


@implementation RILinuxCommandsViewController


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

- (void)reloadData {
    [_controller reloadData];
    [_tableView reloadData];
}

#pragma mark Actions

#pragma mark Initialization

- (void)setup {
    [super setup];
    
    [self setTitle:LUITranslate(@"Linux commands")];
    [self registerTitleWithTranslationKey:@"Linux commands"];
    
    _controller = [[RICommandsController alloc] init];
}

#pragma mark Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}


@end
