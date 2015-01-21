//
//  RIBrowserController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 20/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIBrowserController.h"
#import <NMSSH/NMSSH.h>
#import <FontAwesomeKit/FAKFontAwesome.h>
#import "RITableViewCell.h"
#import "NSObject+CoreData.h"


@interface RIBrowserController () <NMSSHSessionDelegate, NMSSHChannelDelegate>

@property (nonatomic, readonly) NMSSHSession *session;

@property (nonatomic, readonly) UIImage *folderIcon;
@property (nonatomic, readonly) UIImage *fileIcon;

@end


@implementation RIBrowserController


#pragma mark Data

- (void)reloadData {
    _foldersData = [self getFolders];
    _filesData = [self getFiles];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if (_requiresReload) {
            _requiresReload();
        }
    });
}

- (NSArray *)parseFileNames:(NSString *)responseString {
    NSArray *lines = [responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *line in lines)  {
        NSString *l = [line stringByReplacingOccurrencesOfString:@"[ ]+" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, line.length)];
        l = [l stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray *elements = [l componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (elements.count == 9) {
            NSString *file = elements[8];
            if (![file isEqualToString:@"."]) {
                if ([file isEqualToString:@".."]) {
                    if (_currentPath.length > 1) {
                        [arr addObject:@{@"name": file}];
                    }
                }
                else {
                    [arr addObject:@{@"name": file, @"user": elements[2], @"permissions": elements[0]}];
                }
            }
        }
    }
    return [arr copy];
}

- (NSDictionary *)fileAtIndexPath:(NSIndexPath *)indexPath {
    return _filesData[indexPath.row];
}

- (NSDictionary *)folderAtIndexPath:(NSIndexPath *)indexPath {
    return _foldersData[indexPath.row];
}

#pragma mark Executing commands

- (NSString *)getPath {
    NSString *path = [_session.channel execute:@"pwd\n" error:nil];
    return path;
}

- (NSArray *)getFolders {
    NSString *foldersString = [_session.channel execute:[NSString stringWithFormat:@"cd %@\nls -la | grep \"^d\"\n", _currentPath] error:nil];
    return [self parseFileNames:foldersString];
}

- (NSArray *)getFiles {
    NSString *filesString = [_session.channel execute:[NSString stringWithFormat:@"cd %@\nls -la | grep -v \"^d\"\n", _currentPath] error:nil];
    return [self parseFileNames:filesString];
}

#pragma mark Settings

- (void)setCurrentPath:(NSString *)currentPath {
    _currentPath = currentPath;
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
                [self reloadData];
            }
        }
        else {
            _currentPath = [_currentPath stringByAppendingPathComponent:folder];
            [self reloadData];
        }
    });
}

- (NSString *)keyPath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"key.pem"];
    return path;
}

- (void)doLoginFailed:(NSError *)error {
    if (_loginFailed) {
        _loginFailed(error);
    }
}

- (void)setAccount:(RIAccount *)account {
    _account = account;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NMSSHLogger logger].logLevel = NMSSHLogLevelInfo;
        [NMSSHLogger logger].enabled = YES;
        
        _session = [NMSSHSession connectToHost:_account.host port:_account.port.intValue withUsername:_account.user];
        [_session setDelegate:self];
        if (_session.isConnected) {
            if (_account.certificate) {
                NSString *path = [self keyPath];
                [_account.certificate.content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
                [_session authenticateByPublicKey:nil privateKey:path andPassword:_account.password];
            }
            else {
                [_session authenticateByPassword:_account.password];
            }
            if (_session.isAuthorized) {
                NSError *err = nil;
                [_session.channel startShell:&err];
                [_session.channel setDelegate:self];
                [_session.channel setRequestPty:YES];
                if(!err) {
                    if (!_currentPath) {
                        _currentPath = [self getPath];
                    }
                    [self reloadData];
                }
                else {
                    [self doLoginFailed:err];
                }
            }
        }
        else {
            [self doLoginFailed:nil];
        }
    });
}

#pragma mark Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        FAKFontAwesome *icon = [FAKFontAwesome folderIconWithSize:20];
        _folderIcon = [UIImage imageWithStackedIcons:@[icon] imageSize:CGSizeMake(22, 22)];
        
        icon = [FAKFontAwesome fileIconWithSize:20];
        _fileIcon = [UIImage imageWithStackedIcons:@[icon] imageSize:CGSizeMake(22, 22)];
    }
    return self;
}

#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? _foldersData.count : _filesData.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return ((BOOL)_foldersData.count ? @"Folders" : nil);
    }
    else {
        return ((BOOL)_filesData.count ? @"Files" : nil);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"historyCell";
    RITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    NSDictionary *object = nil;
    if (indexPath.section == 0) {
        [cell.imageView setImage:_folderIcon];
        
        object = _foldersData[indexPath.row];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else {
        [cell.imageView setImage:_fileIcon];
        
        object = _filesData[indexPath.row];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    [cell.textLabel setText:object[@"name"]];
    if (object[@"user"]) {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"Owner: %@ Permissions: %@", object[@"user"], object[@"permissions"]]];
    }
    else {
        [cell.detailTextLabel setText:nil];
    }
    
    return cell;
}


@end
