//
//  RIBrowserViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 20/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIBrowserViewController.h"
#import <DLSFTPClient/DLSFTPFile.h>
#import <FontAwesomeKit/FAKFontAwesome.h>
#import "RIBrowserTableViewCell.h"
#import "RIPathLabel.h"
#import "RIBrowserController.h"


@interface RIBrowserViewController () <UITableViewDelegate>

@property (nonatomic, readonly) RIBrowserController *controller;

@property (nonatomic, readonly) UITableView *tableView;

@property (nonatomic, readonly) RIPathLabel *pathLabel;
@property (nonatomic, readonly) UIToolbar *bottomToolbar;

@end


@implementation RIBrowserViewController


#pragma mark Creating elements

- (void)createPreloader {
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [ai startAnimating];
    UIBarButtonItem *loading = [[UIBarButtonItem alloc] initWithCustomView:ai];
    [self.navigationItem setRightBarButtonItem:loading animated:YES];
}

- (void)createReloadButton {
    UIBarButtonItem *loading = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadData)];
    [self.navigationItem setRightBarButtonItem:loading animated:YES];
}

- (void)createControlButtons {
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didClickCloseButton:)];
    [self.navigationItem setLeftBarButtonItem:close];
    
    _bottomToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 44), self.view.frame.size.width, 44)];
    [_bottomToolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    
    FAKFontAwesome *icon = [FAKFontAwesome editIconWithSize:20];
    UIBarButtonItem *insert = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithStackedIcons:@[icon] imageSize:CGSizeMake(22, 22)] style:UIBarButtonItemStyleDone target:self action:@selector(didClickInsertButton:)];
    
    UIBarButtonItem *flexi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    icon = [FAKFontAwesome paperclipIconWithSize:20];
    UIBarButtonItem *copy = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithStackedIcons:@[icon] imageSize:CGSizeMake(22, 22)] style:UIBarButtonItemStyleDone target:self action:@selector(didClickCopyButton:)];
    
    [_bottomToolbar setItems:@[insert, flexi, copy]];
    [self.view addSubview:_bottomToolbar];
}

- (void)createPathLabel {
    CGRect r = self.view.bounds;
    
    r.size.height = 36;
    _pathLabel = [[RIPathLabel alloc] initWithFrame:r];
    [_pathLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [_pathLabel setText:@"Loading ..."];
    [self.view addSubview:_pathLabel];
}

- (void)createTableView {
    CGRect r = self.view.bounds;
    r.origin.y += 36;
    r.size.height -= (36 + 44);
    _tableView = [[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_tableView setDelegate:self];
    [_tableView setDataSource:_controller];
    [self.view addSubview:_tableView];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [self createTableView];
    [self createPathLabel];
    [self createControlButtons];
}

#pragma mark Settings

- (void)reloadData {
    [self createPreloader];
    [_controller reloadData];
}

- (void)showError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void)setAccount:(RIAccount *)account {
    _account = account;
    
    [self createPreloader];
    
    __typeof(self) __weak weakSelf = self;
    
    _controller = [[RIBrowserController alloc] init];
    [_controller setRequiresReload:^{
        [weakSelf.tableView reloadData];
        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [weakSelf createReloadButton];
    }];
    [_controller setPathChanged:^(NSString *path) {
        [weakSelf.pathLabel setText:path];
    }];
    [_controller setLoginFailed:^(NSError *error) {
        [weakSelf showError:error];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    [_controller setFailure:^(NSError *error) {
        [weakSelf showError:error];
    }];
    [_controller setAccount:_account];
    
    [_tableView setDataSource:_controller];
}

#pragma mark Actions

- (void)didClickCloseButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didClickInsertButton:(UIBarButtonItem *)sender {
    if (_insertPath) {
        _insertPath(_pathLabel.text);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didClickCopyButton:(UIBarButtonItem *)sender {
    [[UIPasteboard generalPasteboard] setString:_pathLabel.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DLSFTPFile *file = [_controller fileAtIndexPath:indexPath];
    if (file.attributes[NSFileType] == NSFileTypeDirectory) {
        [self createPreloader];
        if ([file.filename isEqualToString:@".."]) {
            [_controller goTo:@".."];
        }
        else {
            [_controller setCurrentPath:file.path];
        }
    }
    else {
        [_pathLabel setText:file.path];
        [tableView reloadData];
    }
}


@end
