//
//  RIEditAccountViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIEditAccountViewController.h"
#import <LUIFramework/LUIFramework.h>
#import <RETableViewManager/RETableViewManager.h>
#import <REValidation/REValidation.h>
#import <FontAwesomeKit/FAKFontAwesome.h>
#import "RICertificatesViewController.h"
#import "RISelectCertificateViewController.h"
#import "RITableView.h"
#import "RETableViewOptionsController.h"
#import "RICertificatesController.h"
#import "NSObject+CoreData.h"


@interface RIEditAccountViewController () <RETableViewManagerDelegate>

@property (nonatomic, readonly) RETableViewManager *manager;

@property (nonatomic, readonly) RETextItem *accountName;
@property (nonatomic, readonly) RETextItem *serverHost;
@property (nonatomic, readonly) RENumberItem *serverPort;
@property (nonatomic, readonly) RETextItem *serverUser;
@property (nonatomic, readonly) RETextItem *serverPassword;
@property (nonatomic, readonly) RERadioItem *serverCertificate;

@property (nonatomic) RICertificate *temporaryCertificate;

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
    if (_temporaryCertificate) {
        [_serverCertificate setValue:_temporaryCertificate.name];
    }
    else {
        [_serverCertificate setValue:LUITranslate(@"Use password")];
    }
}

- (void)setAccount:(RIAccount *)account {
    _account = account;
    _temporaryCertificate = _account.certificate;
    [self assignValues];
}

#pragma mark Creating elements

- (void)createControls {
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:LUITranslate(@"Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(closePressed:)];
    [self.navigationItem setLeftBarButtonItem:cancel];
    
    FAKFontAwesome *settingsIcon = [FAKFontAwesome certificateIconWithSize:20];
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithStackedIcons:@[settingsIcon] imageSize:CGSizeMake(22, 22)] style:UIBarButtonItemStyleDone target:self action:@selector(settingsPressed:)];
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:LUITranslate(@"Save") style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)];
    [self.navigationItem setRightBarButtonItems:@[save, settings]];
}

- (void)createTableElements {
    __typeof(self) __weak weakSelf = self;
    
    _manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    
    // Register error messages
    NSDictionary *messages = @{
                               @"com.REValidation.presence": LUITranslate(@"%@ can't be blank."),
                               @"com.REValidation.minimumLength": LUITranslate(@"%@ is too short (minimum is %i characters)."),
                               @"com.REValidation.maximumLength": LUITranslate(@"%@ is too long (maximum is %i characters)."),
                               @"com.REValidation.email": LUITranslate(@"%@ is not a valid email."),
                               @"com.REValidation.url": LUITranslate(@"%@ is not a valid url.")
                               };
    [REValidation setErrorMessages:messages];
    
    // Creating sections
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:LUITranslate(@"Account")];
    [_manager addSection:section];
    
    _accountName = [RETextItem itemWithTitle:LUITranslate(@"Name") value:nil placeholder:LUITranslate(@"Account name")];
    [_accountName setValidators:@[@"presence", @"length(1, 999)"]];
    [_accountName setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [section addItem:_accountName];
    
    section = [RETableViewSection sectionWithHeaderTitle:LUITranslate(@"Server")];
    [_manager addSection:section];
    
    _serverHost = [RETextItem itemWithTitle:LUITranslate(@"Host") value:nil placeholder:LUITranslate(@"my.example-host.com")];
    [_serverHost setValidators:@[@"presence"]];
    [_serverHost setKeyboardType:UIKeyboardTypeURL];
    [_serverHost setAutocorrectionType:UITextAutocorrectionTypeNo];
    [section addItem:_serverHost];
    
    _serverPort = [RENumberItem itemWithTitle:LUITranslate(@"Port") value:@"22" placeholder:@"22" format:@"XXXXXXXX"];
    [_serverPort setValidators:@[@"presence", @"length(1, 8)"]];
    [section addItem:_serverPort];
    
    _serverUser = [RETextItem itemWithTitle:LUITranslate(@"User") value:nil placeholder:LUITranslate(@"ec2-user")];
    [_serverUser setValidators:@[@"presence"]];
    [_serverUser setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_serverUser setAutocorrectionType:UITextAutocorrectionTypeNo];
    [section addItem:_serverUser];
    
    _serverPassword = [RETextItem itemWithTitle:LUITranslate(@"Password") value:nil placeholder:LUITranslate(@"password")];
    [_serverPassword setSecureTextEntry:YES];
    [section addItem:_serverPassword];
    
    _serverCertificate = [RERadioItem itemWithTitle:LUITranslate(@"Certificate") accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        // Present options
        RISelectCertificateViewController *c = [[RISelectCertificateViewController alloc] init];
        [c setDidSelectCertificate:^(RICertificate *certificate) {
            [weakSelf setTemporaryCertificate:certificate];
            [weakSelf assignValues];
            [weakSelf.serverCertificate reloadRowWithAnimation:UITableViewRowAnimationNone];
        }];
        [weakSelf.navigationController pushViewController:c animated:YES];
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

- (void)settingsPressed:(UIBarButtonItem *)sender {
    RICertificatesViewController *c = [[RICertificatesViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:c];
    [self presentViewController:nc animated:YES completion:nil];
}

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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LUITranslate(@"Errors") message:errorString delegate:nil cancelButtonTitle:LUITranslate(@"OK") otherButtonTitles:nil];
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
        [_account setCertificate:_temporaryCertificate];
        [_account setPassword:_serverPassword.value];
        [self.coreData saveContext];
        if (_dismissController) {
            _dismissController(self, _account);
        }
    }
}


@end
