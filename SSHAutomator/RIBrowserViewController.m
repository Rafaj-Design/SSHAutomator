//
//  RIBrowserViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 20/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIBrowserViewController.h"
#import <FontAwesomeKit/FAKFontAwesome.h>
#import "RIBrowserController.h"


@interface RIBrowserViewController () <UITableViewDelegate>

@property (nonatomic, readonly) RIBrowserController *controller;

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

- (void)createControlButtons {
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didClickCloseButton:)];
    [self.navigationItem setLeftBarButtonItem:close];
    
    _bottomToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    FAKFontAwesome *icon = [FAKFontAwesome editIconWithSize:20];
    UIBarButtonItem *insert = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithStackedIcons:@[icon] imageSize:CGSizeMake(22, 22)] style:UIBarButtonItemStyleDone target:self action:@selector(didClickInsertButton:)];
    
    UIBarButtonItem *flexi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    icon = [FAKFontAwesome paperclipIconWithSize:20];
    UIBarButtonItem *copy = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithStackedIcons:@[icon] imageSize:CGSizeMake(22, 22)] style:UIBarButtonItemStyleDone target:self action:@selector(didClickCopyButton:)];
    
    [_bottomToolbar setItems:@[insert, flexi, copy]];
}

#pragma mark Settings

- (void)setAccount:(RIAccount *)account {
    _account = account;
    
    [self createPreloader];
    
    __typeof(self) __weak weakSelf = self;
    
    _controller = [[RIBrowserController alloc] init];
    [_controller setRequiresReload:^{
        [weakSelf.tableView reloadData];
        [weakSelf.navigationItem setRightBarButtonItem:nil animated:YES];
    }];
    [_controller setAccount:_account];
    
    [self.tableView setDataSource:_controller];
}

#pragma mark Actions

- (void)didClickCloseButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didClickInsertButton:(UIBarButtonItem *)sender {
    if (_insertPath) {
        _insertPath(_controller.currentPath);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didClickCopyButton:(UIBarButtonItem *)sender {
    [[UIPasteboard generalPasteboard] setString:_controller.currentPath];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createControlButtons];
}

#pragma mark Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self createPreloader];
        
        NSDictionary *d = [_controller folderAtIndexPath:indexPath];
        [_controller goTo:d[@"name"]];
    }
    else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:!cell.selected animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1 && _controller.foldersData.count > 0) {
        return 44;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return (section == 0) ? nil : _bottomToolbar;
}


@end
