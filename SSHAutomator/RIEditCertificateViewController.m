//
//  RIEditCertificateViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 17/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIEditCertificateViewController.h"
#import <LUIFramework/LUIFramework.h>
#import <RETableViewManager/RETableViewManager.h>
#import "RICertificate.h"
#import "NSObject+CoreData.h"


@interface RIEditCertificateViewController () <RETableViewManagerDelegate>

@property (nonatomic, readonly) RETableViewManager *manager;

@property (nonatomic, readonly) RETextItem *certificateName;

@end


@implementation RIEditCertificateViewController


#pragma mark Settings

- (void)assignValues {
    if (_certificate) {
        [_certificateName setValue:_certificate.name];
    }
}

- (void)setCertificate:(RICertificate *)certificate {
    _certificate = certificate;
    [self assignValues];
}

#pragma mark Creating elements

- (void)createControls {
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:LUITranslate(@"Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(closePressed:)];
    [self.navigationItem setLeftBarButtonItem:cancel];
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:LUITranslate(@"Save") style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)];
    [self.navigationItem setRightBarButtonItem:save];
}

- (void)createTableElements {
    _manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:LUITranslate(@"Certificate details")];
    [_manager addSection:section];
    
    _certificateName = [RETextItem itemWithTitle:LUITranslate(@"Name") value:nil placeholder:LUITranslate(@"Certificate name")];
    [section addItem:_certificateName];
    
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LUITranslate(@"Errors") message:errorString delegate:nil cancelButtonTitle:LUITranslate(@"Ok") otherButtonTitles:nil];
        [alert show];
    }
    else {
        if (!_certificate) {
            _certificate = [self.coreData newCertificate];
        }
        [_certificate setName:_certificateName.value];
        [self.coreData saveContext];
        if (_dismissController) {
            _dismissController(self, _certificate);
        }
    }
}


@end
