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


#pragma mark Settings

- (void)assignValues {
    if (_account) {
        [_accountName setValue:_account.name];
        [_serverHost setValue:_account.host];
        [_serverPort setValue:_account.port];
        [_serverUser setValue:_account.user];
        [_serverPassword setValue:_account.password];
    }
}

- (void)setAccount:(RIAccount *)account {
    _account = account;
    [self assignValues];
}

#pragma mark Creating elements

- (void)createControls {
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closePressed:)];
    [self.navigationItem setLeftBarButtonItem:cancel];
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
    [self.navigationItem setRightBarButtonItem:save];
}

- (void)createTableElements {
    __typeof(self) __weak weakSelf = self;
    
    _manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"Account"];
    [_manager addSection:section];
    
    _accountName = [RETextItem itemWithTitle:@"Name" value:nil placeholder:@"Account name"];
    [_accountName setValidators:@[@"presence", @"length(1, 999)"]];
    [section addItem:_accountName];
    
    section = [RETableViewSection sectionWithHeaderTitle:@"Server"];
    [_manager addSection:section];
    
    _serverHost = [RETextItem itemWithTitle:@"Host" value:nil placeholder:@"my.example-host.com"];
    [_serverHost setValidators:@[@"presence"]];
    [section addItem:_serverHost];
    
    _serverPort = [RENumberItem itemWithTitle:@"Port" value:@"22" placeholder:@"22" format:@"XXXXXXXX"];
    [_serverPort setValidators:@[@"presence", @"length(1, 8)"]];
    [section addItem:_serverPort];
    
    _serverUser = [RETextItem itemWithTitle:@"User" value:nil placeholder:@"ec2-user"];
    [_serverUser setValidators:@[@"presence"]];
    [section addItem:_serverUser];
    
    _serverPassword = [RETextItem itemWithTitle:@"Password" value:nil placeholder:@"mySup3rs3cr3tP4ssw0rd (optional)"];
    [_serverPassword setSecureTextEntry:YES];
    [section addItem:_serverPassword];
    
    _serverCertificate = [RERadioItem itemWithTitle:@"Certificate" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 1; i < 4; i++) {
            [options addObject:[NSString stringWithFormat:@"Option %li", (long) i]];
        }
        
        // Present options controller
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem){
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            [item reloadRowWithAnimation:UITableViewRowAnimationNone];
        }];
        
        // Adjust styles
        [optionsController setDelegate:weakSelf];
        [optionsController setStyle:section.style];
        if (weakSelf.tableView.backgroundView == nil) {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        
        // Push the options controller
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];
    [section addItem:_serverCertificate];
    
    [self assignValues];
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

#pragma mark Actions

- (void)closePressed:(UIBarButtonItem *)sender {
    if (_dismissController) {
        _dismissController(self, nil);
    }
}

- (void)savePressed:(UIBarButtonItem *)sender {
    NSArray *managerErrors = self.manager.errors;
    if (managerErrors.count > 0) {
        NSMutableArray *errors = [NSMutableArray array];
        for (NSError *error in managerErrors) {
            [errors addObject:error.localizedDescription];
        }
        NSString *errorString = [errors componentsJoinedByString:@"\n"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        if (!_account) {
            _account = [self.coreData newAccount];
        }
        [_account setName:_accountName.value];
        [_account setHost:_serverHost.value];
        [_account setPort:_serverPort.value];
        [_account setUser:_serverUser.value];
        [_account setPassword:_serverPassword.value];
        [self.coreData saveContext];
        if (_dismissController) {
            _dismissController(self, _account);
        }
    }
}


@end
