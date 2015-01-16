//
//  RIJobsViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIJobsViewController.h"
#import "RIJobsTableView.h"
#import "RIJobsController.h"
#import "RIAccount.h"


@interface RIJobsViewController () <UITableViewDelegate>

@property (nonatomic, readonly) RIJobsController *controller;
@property (nonatomic, readonly) RIJobsTableView *tableView;

@property (nonatomic, readonly) UIBarButtonItem *editButton;
@property (nonatomic, readonly) UIBarButtonItem *doneButton;
@property (nonatomic, readonly) UIBarButtonItem *addButton;

@end


@implementation RIJobsViewController


#pragma mark Creating elements

- (void)createControlButtons {
    _editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed:)];
    _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editPressed:)];
    _addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addJobPressed:)];
    
    [self.navigationItem setRightBarButtonItems:@[_editButton, _addButton]];
}

- (void)createTableView {
    _tableView = [[RIJobsTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setDataSource:_controller];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTableView];
    [self createControlButtons];
}

#pragma mark Settings

- (void)setAccount:(RIAccount *)account {
    _account = account;
    
    [self setTitle:_account.name];
    
    __typeof(self) __weak weakSelf = self;
    _controller = [[RIJobsController alloc] init];
    [_controller setRequiresReload:^{
        [weakSelf reloadData];
    }];
}

- (void)reloadData {
    [_controller reloadData];
    [_tableView reloadData];
}

#pragma mark Actions

- (void)addJobPressed:(UIBarButtonItem *)sender {
//    __typeof(self) __weak weakSelf = self;
//    RIEditAccountViewController *c = [[RIEditAccountViewController alloc] init];
//    [c setDismissController:^(RIEditAccountViewController *controller, RIAccount *account) {
//        [weakSelf reloadData];
//        [controller dismissViewControllerAnimated:YES completion:nil];
//    }];
//    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:c];
//    [self presentViewController:nc animated:YES completion:nil];
}

- (void)editPressed:(UIBarButtonItem *)sender {
    [_tableView setEditing:!_tableView.isEditing animated:YES];
    [self.navigationItem setRightBarButtonItems:@[(_tableView.isEditing ? _doneButton : _editButton), _addButton] animated:YES];
}

#pragma mark Initialization

- (void)setup {
    [super setup];
}

#pragma mark Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    RIJobsViewController *c = [[RIJobsViewController alloc] init];
//    [c setAccount:[_accountsController accountAtIndexPath:indexPath]];
//    [self.navigationController pushViewController:c animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
//    __typeof(self) __weak weakSelf = self;
//    RIEditAccountViewController *c = [[RIEditAccountViewController alloc] init];
//    [c setAccount:[_accountsController accountAtIndexPath:indexPath]];
//    [c setDismissController:^(RIEditAccountViewController *controller, RIAccount *account) {
//        [weakSelf reloadData];
//        [controller dismissViewControllerAnimated:YES completion:nil];
//    }];
//    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:c];
//    [self presentViewController:nc animated:YES completion:nil];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


@end
