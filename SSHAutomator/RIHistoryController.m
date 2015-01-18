//
//  RIHistoryController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 18/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIHistoryController.h"
#import "RITableView.h"
#import "RITableViewCell.h"
#import "NSObject+CoreData.h"


@interface RIHistoryController ()

@property (nonatomic, readonly) NSArray *data;
@property (nonatomic, readonly) NSDateFormatter *formatter;

@end


@implementation RIHistoryController


#pragma mark Data management

- (RIHistory *)historyAtIndexPath:(NSIndexPath *)indexPath {
    return _data[indexPath.row];
}

- (NSArray *)history {
    return _data;
}

#pragma mark Settings

- (void)setJob:(RIJob *)job {
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateStyle:NSDateFormatterLongStyle];
    [_formatter setTimeStyle:NSDateFormatterLongStyle];
    
    _job = job;
    [self reloadData];
}

- (void)reloadData {
    _data = [self.coreData historyForJob:_job];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"historyCell";
    RITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    RIHistory *object = [self historyAtIndexPath:indexPath];
    [cell.detailTextLabel setText:[_formatter stringFromDate:object.date]];
    
    return cell;
}


@end
