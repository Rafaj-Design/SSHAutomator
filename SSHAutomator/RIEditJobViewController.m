//
//  RIEditJobViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIEditJobViewController.h"
#import <RETableViewManager/RETableViewManager.h>
#import "RIJob.h"
#import "NSObject+CoreData.h"


@interface RIEditJobViewController () <RETableViewManagerDelegate>

@property (nonatomic, readonly) RETableViewManager *manager;

@property (nonatomic, readonly) RETextItem *jobName;

@end


@implementation RIEditJobViewController


#pragma mark Settings

- (void)assignValues {
    if (_job) {
        [_jobName setValue:_job.name];
    }
}

- (void)setJob:(RIJob *)job {
    _job = job;
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
    //__typeof(self) __weak weakSelf = self;
    
    _manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"Job details"];
    [_manager addSection:section];
    
    _jobName = [RETextItem itemWithTitle:@"Name" value:nil placeholder:@"Account name"];
    [_jobName setValidators:@[@"presence", @"length(1, 999)"]];
    [_jobName setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [section addItem:_jobName];
    
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
        if (!_job) {
            _job = [self.coreData newJobForAccount:_account];
        }
        [_job setName:_jobName.value];
        [self.coreData saveContext];
        if (_dismissController) {
            _dismissController(self, _job);
        }
    }
}


@end
