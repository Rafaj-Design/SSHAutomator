//
//  RICertificatesViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RICertificatesViewController.h"
#import "RICertificatesController.h"
#import "RICertificatesTableView.h"
#import "GCDWebUploader.h"


@interface RICertificatesViewController () <UITableViewDelegate, GCDWebUploaderDelegate>

@property (nonatomic, readonly) RICertificatesController *controller;
@property (nonatomic, readonly) RICertificatesTableView *tableView;

@property (nonatomic, readonly) UIBarButtonItem *editButton;
@property (nonatomic, readonly) UIBarButtonItem *doneButton;

@property (nonatomic, readonly) GCDWebUploader *webUploader;

@end


@implementation RICertificatesViewController


#pragma mark Creating elements

- (void)createUploader {
    NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    dirPath = [dirPath stringByAppendingPathComponent:@"certificates"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    BOOL pathExists = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    if (!pathExists) [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    _webUploader = [[GCDWebUploader alloc] initWithUploadDirectory:dirPath];
    [_webUploader setAllowHiddenItems:NO];
    [_webUploader setAllowedFileExtensions:@[@"pem"]];
    [_webUploader setDelegate:self];
    [_webUploader start];
    
    [_controller setUploaderUrlString:_webUploader.serverURL.absoluteString];
}

- (void)createControlButtons {
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closePressed:)];
    [self.navigationItem setLeftBarButtonItem:close];
    
    _editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed:)];
    _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editPressed:)];
    
    [self.navigationItem setRightBarButtonItems:@[_editButton]];
}

- (void)createTableView {
    _tableView = [[RICertificatesTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setDataSource:_controller];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTableView];
    [self createControlButtons];
    [self createUploader];
}

#pragma mark Settings

- (void)reloadData {
    [_controller reloadData];
    [_tableView reloadData];
}

#pragma mark Actions

- (void)closePressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editPressed:(UIBarButtonItem *)sender {
    [_tableView setEditing:!_tableView.isEditing animated:YES];
    [self.navigationItem setRightBarButtonItems:@[(_tableView.isEditing ? _doneButton : _editButton)] animated:YES];
}

#pragma mark Initialization

- (void)setup {
    [super setup];
    
    _controller = [[RICertificatesController alloc] init];
}

#pragma mark Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

#pragma mark Web uploader delegate

- (void)webUploader:(GCDWebUploader *)uploader didCreateDirectoryAtPath:(NSString *)path {
    
}

- (void)webUploader:(GCDWebUploader *)uploader didUploadFileAtPath:(NSString *)path {
    [self reloadData];
}

- (void)webUploader:(GCDWebUploader *)uploader didDeleteItemAtPath:(NSString *)path {
    [self reloadData];
}

- (void)webUploader:(GCDWebUploader *)uploader didMoveItemFromPath:(NSString *)fromPath toPath:(NSString *)toPath {
    [self reloadData];
}


@end
