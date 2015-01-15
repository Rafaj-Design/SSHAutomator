//
//  RIEditAccountViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIEditAccountViewController.h"
#import <RETableViewManager/RETableViewManager.h>
#import "RITableView.h"
#import "RETableViewOptionsController.h"
#import "RIAccount.h"
#import "NSObject+CoreData.h"


@interface RIEditAccountViewController () <RETableViewManagerDelegate>

@property (nonatomic, readonly) RETableViewManager *manager;

@property (nonatomic, readonly) RETextItem *accountName;
@property (nonatomic, readonly) RETextItem *serverHost;
@property (nonatomic, readonly) RENumberItem *serverPort;
@property (nonatomic, readonly) RETextItem *serverUser;
@property (nonatomic, readonly) RETextItem *serverPassword;
@property (nonatomic, readonly) RERadioItem *serverCertificate;

@end


@implementation RIEditAccountViewController


#pragma mark Actions

- (void)closePressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)savePressed:(UIBarButtonItem *)sender {
    
}

#pragma mark Creating elements

- (void)createControls {
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closePressed:)];
    [self.navigationItem setLeftBarButtonItem:cancel];
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(savePressed:)];
    [self.navigationItem setRightBarButtonItem:save];
}

- (void)createTableElements {
    __typeof (&*self) __weak weakSelf = self;
    
    _manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"Account"];
    [_manager addSection:section];
    
    _accountName = [RETextItem itemWithTitle:@"Name" value:nil placeholder:@"Account name"];
    [section addItem:_accountName];
    
    section = [RETableViewSection sectionWithHeaderTitle:@"Server"];
    [_manager addSection:section];
    
    _serverHost = [RETextItem itemWithTitle:@"Host" value:nil placeholder:@"my.example-host.com"];
    [section addItem:_serverHost];
    
    _serverPort = [RENumberItem itemWithTitle:@"Port" value:@"22" placeholder:@"22" format:@"XXXX"];
    [section addItem:_serverPort];
    
    _serverUser = [RETextItem itemWithTitle:@"User" value:nil placeholder:@"ec2-user"];
    [section addItem:_serverUser];
    
    _serverPassword = [RETextItem itemWithTitle:@"Password" value:nil placeholder:@"mySup3rs3cr3tP4ssw0rd"];
    [_serverPassword setSecureTextEntry:YES];
    [section addItem:_serverPassword];
    
    _serverCertificate = [RERadioItem itemWithTitle:@"Certificate" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 1; i < 40; i++)
            [options addObject:[NSString stringWithFormat:@"Option %li", (long) i]];
        
        // Present options controller
        //
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem){
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        // Adjust styles
        //
        [optionsController setDelegate:weakSelf];
        [optionsController setStyle:section.style];
        if (weakSelf.tableView.backgroundView == nil) {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        
        // Push the options controller
        //
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];
    [section addItem:_serverCertificate];
}

- (void)createAllElements {
    [self createTableElements];
    [self createControls];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createAllElements];
}



@end
