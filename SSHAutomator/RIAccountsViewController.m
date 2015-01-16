//
//  RIAccountsViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIAccountsViewController.h"
#import <FontAwesomeKit/FAKFontAwesome.h>
#import "RIEditAccountViewController.h"
#import "RICertificatesViewController.h"
#import "RIJobsViewController.h"
#import "RIAccountsController.h"
#import "RIAccountsTableView.h"
#import "RIConfig.h"


@interface RIAccountsViewController () <UITableViewDelegate>

@property (nonatomic, readonly) RIAccountsController *controller;
@property (nonatomic, readonly) RIAccountsTableView *tableView;

@property (nonatomic, readonly) UIBarButtonItem *editButton;
@property (nonatomic, readonly) UIBarButtonItem *doneButton;
@property (nonatomic, readonly) UIBarButtonItem *addButton;

@end


@implementation RIAccountsViewController


#pragma mark Creating elements

- (void)createControlButtons {
    FAKFontAwesome *settingsIcon = [FAKFontAwesome gearsIconWithSize:15];
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithStackedIcons:@[settingsIcon] imageSize:CGSizeMake(22, 22)] style:UIBarButtonItemStyleDone target:self action:@selector(settingsPressed:)];
    [self.navigationItem setLeftBarButtonItem:settings];
    
    _editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed:)];
    _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editPressed:)];
    _addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAccountPressed:)];
    
    [self.navigationItem setRightBarButtonItems:@[_editButton, _addButton]];
}

- (void)createTableView {
    _tableView = [[RIAccountsTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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

- (void)reloadData {
    [_controller reloadData];
    [_tableView reloadData];
}

#pragma mark Actions

- (void)settingsPressed:(UIBarButtonItem *)sender {
    RICertificatesViewController *c = [[RICertificatesViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:c];
    [self presentViewController:nc animated:YES completion:nil];
}

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
    [self.navigationItem setRightBarButtonItems:@[(_tableView.isEditing ? _doneButton : _editButton), _addButton] animated:YES];
}

#pragma mark Initialization

- (void)setup {
    [super setup];
    
    __typeof(self) __weak weakSelf = self;
    _controller = [[RIAccountsController alloc] init];
    [_controller setRequiresReload:^{
        [weakSelf reloadData];
    }];
}

#pragma mark Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RIJobsViewController *c = [[RIJobsViewController alloc] init];
    [c setAccount:[_controller accountAtIndexPath:indexPath]];
    [self.navigationController pushViewController:c animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    __typeof(self) __weak weakSelf = self;
    RIEditAccountViewController *c = [[RIEditAccountViewController alloc] init];
    [c setAccount:[_controller accountAtIndexPath:indexPath]];
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
