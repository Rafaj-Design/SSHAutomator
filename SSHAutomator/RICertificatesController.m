//
//  RICertificatesController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RICertificatesController.h"
#import "RITableView.h"
#import "RITableViewCell.h"
#import "NSObject+CoreData.h"


@interface RICertificatesController ()

@property (nonatomic, readonly) NSString *dirPath;
@property (nonatomic, readonly) NSFileManager *fileManager;

@property (nonatomic, readonly) NSArray *data;

@end


@implementation RICertificatesController


#pragma mark Data management

- (NSArray *)certificateAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *object = _data[indexPath.row];
    return object;
}

- (NSArray *)certificates {
    return _data;
}

#pragma mark Settings

- (void)reloadData {
    NSError *error = nil;
    NSArray *directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_dirPath error:&error];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *fileName in directoryContents) {
        NSString *fullPath = [_dirPath stringByAppendingPathComponent:fileName];
        BOOL isDir = YES;
        if ([_fileManager fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if (!isDir) [arr addObject:@[fileName, fullPath]];
        }
    }
    _data = [arr copy];
}

- (void)setUploaderUrlString:(NSString *)uploaderUrlString {
    _uploaderUrlString = uploaderUrlString;
    if (_requiresReload) {
        _requiresReload();
    }
}

#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 1 : _data.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0) ? NO : YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? @"Uploader" : @"Certificates";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"accountCell";
    RITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    if (indexPath.section == 0) {
        NSString *text = (_uploaderUrlString ? _uploaderUrlString : @"Loading uploader URL ...");
        [cell.textLabel setText:text];
        [cell.detailTextLabel setText:@"Please connect to this URL from your browser."];
    }
    else {
        NSArray *object = _data[indexPath.row];
        [cell.textLabel setText:object[0]];
        [cell.detailTextLabel setText:nil];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (editingStyle) {
        case UITableViewCellEditingStyleNone:
            
            break;
        case UITableViewCellEditingStyleDelete: {
            if (_requiresReload) {
                _requiresReload();
            }
            break;
        }
        case UITableViewCellEditingStyleInsert:
            
            break;
            
        default:
            break;
    }
}

#pragma mark Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _dirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        _dirPath = [_dirPath stringByAppendingPathComponent:@"certificates"];
        
        _fileManager = [NSFileManager defaultManager];
        BOOL isDir = YES;
        BOOL pathExists = [_fileManager fileExistsAtPath:_dirPath isDirectory:&isDir];
        if (!pathExists) [_fileManager createDirectoryAtPath:_dirPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        [self reloadData];
    }
    return self;
}


@end
