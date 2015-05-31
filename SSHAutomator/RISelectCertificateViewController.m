//
//  RISelectCertificateViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 18/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RISelectCertificateViewController.h"
#import <LUIFramework/LUIFramework.h>
#import "RICertificatesController.h"
#import "RICertificatesTableView.h"


@interface RISelectCertificateViewController () <UITableViewDelegate>

@property (nonatomic, readonly) RICertificatesController *controller;
@property (nonatomic, readonly) RICertificatesTableView *tableView;

@end


@implementation RISelectCertificateViewController


#pragma mark Creating elements

- (void)createTableView {
    _tableView = [[RICertificatesTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_tableView setDataSource:_controller];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTableView];
}

#pragma mark Settings

- (void)reloadData {
    [_controller reloadData];
    [_tableView reloadData];
}

#pragma mark Actions

#pragma mark Initialization

- (void)setup {
    [super setup];
    
    [self setTitle:LUITranslate(@"Select certificate")];
    
    _controller = [[RICertificatesController alloc] init];
}

#pragma mark Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_didSelectCertificate) {
        NSInteger index = (indexPath.row - 1);
        RICertificate *c = (index >= 0) ? [_controller certificateAtIndex:index] : nil;
        _didSelectCertificate(c);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


@end
