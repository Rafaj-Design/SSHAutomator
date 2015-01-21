//
//  RIBrowserController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 20/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIBrowserController.h"
#import <DLSFTPClient/DLSFTPConnection.h>
#import <DLSFTPClient/DLSFTPFile.h>
#import <DLSFTPClient/DLSFTPListFilesRequest.h>
#import <FontAwesomeKit/FAKFontAwesome.h>
#import "RIBrowserTableViewCell.h"
#import "NSObject+CoreData.h"


@interface RIBrowserController ()

@property (nonatomic, readonly) DLSFTPConnection *connection;

@property (nonatomic, readonly) UIImage *folderIcon;
@property (nonatomic, readonly) UIImage *fileIcon;

@property (nonatomic, strong) NSArray *data;

@end


@implementation RIBrowserController


#pragma mark Data

- (void)reloadData {
    [self updateFiles];
}

- (DLSFTPFile *)fileAtIndexPath:(NSIndexPath *)indexPath {
    return _data[indexPath.row];
}

#pragma mark Executing commands

- (void)updateFiles {
    __typeof(self) __weak weakSelf = self;
    
    DLSFTPClientArraySuccessBlock successBlock = ^(NSArray *files) {
        if (_currentPath.length > 1 && ![_currentPath isEqualToString:@"/"]) {
            NSMutableArray *arr = [files mutableCopy];
            DLSFTPFile *parent = [[DLSFTPFile alloc] initWithPath:@".." attributes:@{NSFileType: NSFileTypeDirectory}];
            [arr insertObject:parent atIndex:0];
            [weakSelf setData:[arr copy]];
        }
        else {
            [weakSelf setData:files];
        }
        [self askForReload];
    };
    
    DLSFTPClientFailureBlock failureBlock = ^(NSError *error) {
        [self doFailure:error];
    };
    
    DLSFTPRequest *request = [[DLSFTPListFilesRequest alloc] initWithDirectoryPath:_currentPath successBlock:successBlock failureBlock:failureBlock];
    [_connection submitRequest:request];
}

#pragma mark Settings

- (void)pathDidChange {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if (_pathChanged) {
            _pathChanged(_currentPath);
        }
    });
}

- (void)doLoginFailed:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if (_loginFailed) {
            _loginFailed(error);
        }
    });
}

- (void)doFailure:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if (_failure) {
            _failure(error);
        }
    });
}

- (void)askForReload {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if (_requiresReload) {
            _requiresReload();
        }
    });
}

- (void)setCurrentPath:(NSString *)currentPath {
    _currentPath = currentPath;
    [self pathDidChange];
    if (_account) {
        [self reloadData];
    }
}

- (void)goTo:(NSString *)folder {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([folder isEqualToString:@"."]) {
            // Do nothing
        }
        else if ([folder isEqualToString:@".."]) {
            if (_currentPath.length > 1 && ![_currentPath isEqualToString:@"/"]) {
                _currentPath = [_currentPath stringByDeletingLastPathComponent];
                [self pathDidChange];
                [self reloadData];
            }
        }
        else {
            _currentPath = [_currentPath stringByAppendingPathComponent:folder];
            [self pathDidChange];
            [self reloadData];
        }
    });
}

- (NSString *)keyPath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"key.pem"];
    return path;
}

- (void)setAccount:(RIAccount *)account {
    _account = account;
    
    if (!_currentPath) {
        _currentPath = @"/";
    }
    
    if (_account.certificate) {
        NSString *path = [self keyPath];
        [_account.certificate.content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        _connection = [[DLSFTPConnection alloc] initWithHostname:_account.host port:_account.port.intValue username:_account.user keypath:path passphrase:nil];
    }
    else {
        _connection = [[DLSFTPConnection alloc] initWithHostname:_account.host port:_account.port.intValue username:_account.user password:_account.password];
    }
    
    __typeof(self) __weak weakSelf = self;
    DLSFTPClientSuccessBlock successBlock = ^{
        [weakSelf pathDidChange];
        [weakSelf reloadData];
    };
    DLSFTPClientFailureBlock failureBlock = ^(NSError *error) {
        [weakSelf doLoginFailed:error];
    };
    [_connection connectWithSuccessBlock:successBlock failureBlock:failureBlock];
}

#pragma mark Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        FAKFontAwesome *icon = [FAKFontAwesome folderIconWithSize:20];
        _folderIcon = [UIImage imageWithStackedIcons:@[icon] imageSize:CGSizeMake(22, 22)];
        
        icon = [FAKFontAwesome fileOIconWithSize:20];
        _fileIcon = [UIImage imageWithStackedIcons:@[icon] imageSize:CGSizeMake(22, 22)];
    }
    return self;
}

#pragma mark Memory management

- (void)dealloc {
    if (_connection.isConnected) {
        [_connection cancelAllRequests];
        [_connection disconnect];
    }
}

#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"historyCell";
    RIBrowserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RIBrowserTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    DLSFTPFile *file = [self fileAtIndexPath:indexPath];
    if (file.attributes[NSFileType] == NSFileTypeDirectory) {
        [cell.imageView setImage:_folderIcon];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        if ([file.filename isEqualToString:@".."]) {
            [cell.detailTextLabel setText:[_currentPath stringByDeletingLastPathComponent]];
        }
        else {
            [cell.detailTextLabel setText:file.path];
        }
    }
    else {
        [cell.imageView setImage:_fileIcon];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell.detailTextLabel setText:[NSByteCountFormatter stringFromByteCount:[file.attributes[NSFileSize] integerValue] countStyle:NSByteCountFormatterCountStyleFile]];
    }
    [cell.textLabel setText:file.filename];
    //[cell setFileSelected:object.isSelected];
    
    return cell;
}


@end
