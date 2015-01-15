//
//  RIAccountsViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIAccountsViewController.h"
#import "RIEditAccountViewController.h"
#import "RIAccountsController.h"
#import "RIAccountsTableView.h"


@interface RIAccountsViewController () <UITableViewDelegate>

@property (nonatomic, readonly) RIAccountsController *accountsController;
@property (nonatomic, readonly) RIAccountsTableView *tableView;

@end


@implementation RIAccountsViewController


#pragma mark Creating elements

- (void)createControlButtons {
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAccountPressed:)];
    [self.navigationItem setRightBarButtonItem:add];
}

- (void)createTableView {
    _tableView = [[RIAccountsTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setDataSource:_accountsController];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTableView];
    [self createControlButtons];
}

#pragma mark Actions

- (void)addAccountPressed:(UIBarButtonItem *)sender {
    RIEditAccountViewController *c = [[RIEditAccountViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:c];
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark Initialization

- (void)setup {
    [super setup];
    
    _accountsController = [[RIAccountsController alloc] init];
}


@end
