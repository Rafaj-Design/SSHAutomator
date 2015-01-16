//
//  RICertificatesViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RICertificatesViewController.h"
#import "RICertificatesController.h"
#import "RICertificatesTableView.h"


@interface RICertificatesViewController () <UITableViewDelegate>

@property (nonatomic, readonly) RICertificatesController *controller;
@property (nonatomic, readonly) RICertificatesTableView *tableView;

@property (nonatomic, readonly) UIBarButtonItem *editButton;
@property (nonatomic, readonly) UIBarButtonItem *doneButton;
@property (nonatomic, readonly) UIBarButtonItem *addButton;

@end


@implementation RICertificatesViewController


#pragma mark Creating elements

- (void)createControlButtons {
    _editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed:)];
    _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editPressed:)];
    _addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCertificatePressed:)];
    
    [self.navigationItem setRightBarButtonItems:@[_editButton, _addButton]];
}

- (void)createTableView {
    _tableView = [[RICertificatesTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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

- (void)addCertificatePressed:(UIBarButtonItem *)sender {
    
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
