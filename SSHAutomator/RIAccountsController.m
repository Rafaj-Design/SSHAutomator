//
//  RIAccountsController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIAccountsController.h"
#import "RITableView.h"
#import "RITableViewCell.h"
#import "NSObject+CoreData.h"


@interface RIAccountsController ()

@property (nonatomic, readonly) NSArray *data;

@end


@implementation RIAccountsController


#pragma mark Data management

- (RIAccount *)accountAtIndexPath:(NSIndexPath *)indexPath {
    RIAccount *object = _data[indexPath.row];
    return object;
}

#pragma mark Settings

- (void)reloadData {
    _data = [self.coreData accounts];
}

#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"accountCell";
    RITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    }
    
    RIAccount *object = _data[indexPath.row];
    [cell.textLabel setText:object.name];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@:%@", object.host, object.port]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (editingStyle) {
        case UITableViewCellEditingStyleNone:
            
            break;
        case UITableViewCellEditingStyleDelete: {
            RIAccount *account = _data[indexPath.row];
            [self.coreData.managedObjectContext deleteObject:account];
            [self.coreData saveContext];
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
        [self reloadData];
    }
    return self;
}


@end
