//
//  RIAccountsViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIAccountsViewController.h"
#import "RIEditAccountViewController.h"
#import "RIJobsViewController.h"
#import "RIAccountsController.h"
#import "RIAccountsTableView.h"


@interface RIAccountsViewController () <UITableViewDelegate>

@property (nonatomic, readonly) RIAccountsController *accountsController;
@property (nonatomic, readonly) RIAccountsTableView *tableView;

@property (nonatomic, readonly) UIBarButtonItem *editButton;
@property (nonatomic, readonly) UIBarButtonItem *doneButton;

@end


@implementation RIAccountsViewController


#pragma mark Creating elements

- (void)createControlButtons {
    _editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed:)];
    [self.navigationItem setLeftBarButtonItem:_editButton];
    
    _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editPressed:)];
    
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

#pragma mark Settings

- (void)reloadData {
    [_accountsController reloadData];
    [_tableView reloadData];
}

#pragma mark Actions

- (void)addAccountPressed:(UIBarButtonItem *)sender {
    __typeof(self) __weak weakSelf = self;
    RIEditAccountViewController *c = [[RIEditAccountViewController alloc] init];
    [c setDismissController:^(RIEditAccountViewController *controller, RIAccount *account) {
        [weakSelf reloadData];
        [controller dismissViewControllerAnimated:YES completion:nil];
    }];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:c];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)editPressed:(UIBarButtonItem *)sender {
    [_tableView setEditing:!_tableView.isEditing animated:YES];
    [self.navigationItem setLeftBarButtonItem:(_tableView.isEditing ? _doneButton : _editButton) animated:YES];
}

#pragma mark Initialization

- (void)setup {
    [super setup];
    
    __typeof(self) __weak weakSelf = self;
    _accountsController = [[RIAccountsController alloc] init];
    [_accountsController setRequiresReload:^{
        [weakSelf reloadData];
    }];
}

#pragma mark Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RIJobsViewController *c = [[RIJobsViewController alloc] init];
    [c setAccount:[_accountsController accountAtIndexPath:indexPath]];
    [self.navigationController pushViewController:c animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    __typeof(self) __weak weakSelf = self;
    RIEditAccountViewController *c = [[RIEditAccountViewController alloc] init];
    [c setAccount:[_accountsController accountAtIndexPath:indexPath]];
    [c setDismissController:^(RIEditAccountViewController *controller, RIAccount *account) {
        [weakSelf reloadData];
        [controller dismissViewControllerAnimated:YES completion:nil];
    }];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:c];
    [self presentViewController:nc animated:YES completion:nil];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


@end
