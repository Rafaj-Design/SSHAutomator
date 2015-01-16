//
//  RIEditTaskViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIEditTaskViewController.h"
#import <RETableViewManager/RETableViewManager.h>
#import "RITask.h"
#import "NSObject+CoreData.h"


@interface RIEditTaskViewController () <RETableViewManagerDelegate>

@property (nonatomic, readonly) RETableViewManager *manager;

@property (nonatomic, readonly) REBoolItem *taskEnabled;
@property (nonatomic, readonly) RELongTextItem *taskCommand;

@end


@implementation RIEditTaskViewController


#pragma mark Settings

- (void)assignValues {
    if (_task) {
        [_taskEnabled setValue:_task.enabled];
        [_taskCommand setValue:_task.command];
    }
}

- (void)setTask:(RITask *)task {
    _task = task;
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
    _manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"Task details"];
    [_manager addSection:section];
    
    _taskEnabled = [REBoolItem itemWithTitle:@"Enabled" value:YES];
    [section addItem:_taskEnabled];
    
    _taskCommand = [RELongTextItem itemWithTitle:nil value:nil placeholder:@"Command, for example: \"ls -a ./\""];
    [_taskCommand setValidators:@[@"presence"]];
    [_taskCommand setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_taskCommand setCellHeight:250];
    [section addItem:_taskCommand];

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
        if (!_task) {
            _task = [self.coreData newTaskForJob:_job];
        }
        [_task setEnabled:_taskEnabled.value];
        [_task setCommand:_taskCommand.value];
        [_task setSort:0];
        [self.coreData saveContext];
        if (_dismissController) {
            _dismissController(self, _task);
        }
    }
}


@end
