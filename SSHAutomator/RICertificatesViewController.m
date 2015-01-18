//
//  RICertificatesViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RICertificatesViewController.h"
#import "RIUploaderViewController.h"
#import "RIEditCertificateViewController.h"
#import "RIManageCertificatesController.h"
#import "RICertificatesTableView.h"
#import "NSObject+CoreData.h"


@interface RICertificatesViewController () <UITableViewDelegate>

@property (nonatomic, readonly) RIManageCertificatesController *controller;
@property (nonatomic, readonly) RICertificatesTableView *tableView;

@property (nonatomic, readonly) UIBarButtonItem *editButton;
@property (nonatomic, readonly) UIBarButtonItem *doneButton;

@end


@implementation RICertificatesViewController


#pragma mark Creating elements

- (void)createControlButtons {
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closePressed:)];
    [self.navigationItem setLeftBarButtonItem:close];
    
    _editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed:)];
    _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editPressed:)];
    
    [self.navigationItem setRightBarButtonItems:@[_editButton]];
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

- (void)closePressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editPressed:(UIBarButtonItem *)sender {
    [_tableView setEditing:!_tableView.isEditing animated:YES];
    [self.navigationItem setRightBarButtonItems:@[(_tableView.isEditing ? _doneButton : _editButton)] animated:YES];
}

#pragma mark Initialization

- (void)setup {
    [super setup];
    
    _controller = [[RIManageCertificatesController alloc] init];
}

#pragma mark Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0 && indexPath.row == 0) {
        RIUploaderViewController *c = [[RIUploaderViewController alloc] init];
        [c setFileUploaded:^(NSString *content, NSString *fileName) {
            RICertificate *cert = [weakSelf.coreData newCertificate];
            [cert setContent:content];
            [cert setName:fileName];
            [weakSelf.coreData saveContext];
            
            [weakSelf reloadData];
        }];
        [self.navigationController pushViewController:c animated:YES];
    }
    else {
        RIEditCertificateViewController *c = [[RIEditCertificateViewController alloc] init];
        [c setCertificate:[_controller certificateAtIndexPath:indexPath]];
        [c setDismissController:^(RIEditCertificateViewController *controller, RICertificate *certificate) {
            [weakSelf.tableView reloadData];
            [controller dismissViewControllerAnimated:YES completion:nil];
        }];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:c];
        [self presentViewController:nc animated:YES completion:nil];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}


@end
