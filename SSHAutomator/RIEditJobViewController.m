//
//  RIEditJobViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIEditJobViewController.h"
#import <RETableViewManager/RETableViewManager.h>
#import <FontAwesomeKit/FAKFontAwesome.h>
#import "RIIconsViewController.h"
#import "RIIconsController.h"
#import "RIJob.h"
#import "RIConfig.h"
#import "NSObject+CoreData.h"


@interface RIEditJobViewController () <RETableViewManagerDelegate>

@property (nonatomic, readonly) RETableViewManager *manager;

@property (nonatomic, readonly) RETableViewItem *icon;
@property (nonatomic, readonly) RETextItem *jobName;

@property (nonatomic) NSString *temporaryIcon;

@end


@implementation RIEditJobViewController


#pragma mark Settings

- (void)assignValues {
    if (_job) {
        [_jobName setValue:_job.name];
    }
    if (_temporaryIcon) {
        //[_icon setValue:@""];
        FAKFontAwesome *icon = [FAKFontAwesome iconWithCode:_temporaryIcon size:20];
        [icon addAttribute:NSForegroundColorAttributeName value:[RIConfig mainColor]];
        [_icon setImage:[UIImage imageWithStackedIcons:@[icon] imageSize:CGSizeMake(50, 50)]];
        [_icon reloadRowWithAnimation:UITableViewRowAnimationNone];
    }
    else {
        //[_icon setValue:@"No icon"];
        [_icon setImage:nil];
    }
}

- (void)setJob:(RIJob *)job {
    _job = job;
    _temporaryIcon = _job.icon;
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
    
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"Job details"];
    [_manager addSection:section];
    
    _icon = [RETableViewItem itemWithTitle:@"Icon" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        // Present options
        RIIconsViewController *c = [[RIIconsViewController alloc] init];
        [c setDidSelectIcon:^(NSString *iconCode) {
            [weakSelf setTemporaryIcon:iconCode];
            [weakSelf assignValues];
            [weakSelf.icon reloadRowWithAnimation:UITableViewRowAnimationNone];
        }];
        [weakSelf.navigationController pushViewController:c animated:YES];
    }];
    [section addItem:_icon];
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self assignValues];
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
        [_job setIcon:_temporaryIcon];
        [_job setName:_jobName.value];
        [self.coreData saveContext];
        if (_dismissController) {
            _dismissController(self, _job);
        }
    }
}


@end
