//
//  RIAccountsViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIAccountsViewController.h"
#import <LUIFramework/LUIFramework.h>
#import "RIEditAccountViewController.h"
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
    _editButton = [[UIBarButtonItem alloc] initWithTitle:LUITranslate(@"Edit") style:UIBarButtonItemStyleDone target:self action:@selector(editPressed:)];
    [_editButton registerTitleWithTranslationKey:@"Edit"];
    
    _doneButton = [[UIBarButtonItem alloc] initWithTitle:LUITranslate(@"Done") style:UIBarButtonItemStyleDone target:self action:@selector(editPressed:)];
    [_doneButton registerTitleWithTranslationKey:@"Done"];
    
    _addButton = [[UIBarButtonItem alloc] initWithTitle:LUITranslate(@"Add") style:UIBarButtonItemStylePlain target:self action:@selector(addAccountPressed:)];
    
    [self.navigationItem setRightBarButtonItems:@[_editButton, _addButton]];
}

- (void)createTableView {
    _tableView = [[RIAccountsTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
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
    
    [self setTitle:LUITranslate(@"Accounts")];
    [self registerTitleWithTranslationKey:@"Accounts"];
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
