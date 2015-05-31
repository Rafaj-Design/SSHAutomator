//
//  RICertificatesController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RICertificatesController.h"
#import <LUIFramework/LUIFramework.h>
#import "RITableView.h"
#import "RITableViewCell.h"
#import "NSObject+CoreData.h"


@interface RICertificatesController ()

@end


@implementation RICertificatesController


#pragma mark Data management

- (RICertificate *)certificateAtIndex:(NSInteger)index {
    RICertificate *object = _data[index];
    return object;
}

- (RICertificate *)certificateAtIndexPath:(NSIndexPath *)indexPath {
    return [self certificateAtIndex:indexPath.row];
}

- (NSArray *)certificates {
    return _data;
}

#pragma mark Settings

- (void)reloadData {
    _data = [self.coreData certificates];
}

#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (_data.count + 1);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"certificateCell";
    RITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    if (indexPath.row == 0) {
         [cell.textLabel setText:LUITranslate(@"Use password")];
    }
    else {
        NSInteger index = (indexPath.row - 1);
        RICertificate *object = _data[index];
        [cell.textLabel setText:object.name];
        [cell.detailTextLabel setText:nil];
    }
    
    return cell;
}

#pragma mark Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self reloadData];
    }
    return self;
}


@end
