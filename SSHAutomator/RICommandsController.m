//
//  RICommandsController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 18/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RICommandsController.h"
#import "RITableView.h"
#import "RITableViewCell.h"
#import "NSObject+CoreData.h"


@interface RICommandsController ()

@property (nonatomic, readonly) NSArray *data;

@end


@implementation RICommandsController


#pragma mark Data management

- (NSArray *)commandAtIndexPath:(NSIndexPath *)indexPath {
    return _data[indexPath.row];
}

- (NSArray *)commands {
    return _data;
}

- (NSString *)trim:(NSString *)string {
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

#pragma mark Settings

- (void)reloadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"commands" ofType:@"txt"];
    NSString *fileString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *line in [fileString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
        NSArray *data = [line componentsSeparatedByString:@"|"];
        if (data.count == 2) {
            [arr addObject:data];
        }
    }
    _data = [arr copy];
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
    static NSString *identifier = @"certificateCell";
    RITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    NSArray *object = [self commandAtIndexPath:indexPath];
    [cell.textLabel setText:object[0]];
    [cell.detailTextLabel setText:object[1]];
    
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
