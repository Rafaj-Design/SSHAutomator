//
//  RITasksController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RITasksController.h"
#import <LUIFramework/LUIFramework.h>
#import <FontAwesomeKit/FAKFontAwesome.h>
#import "RITableView.h"
#import "RITableViewCell.h"
#import "RIConfig.h"
#import "NSObject+CoreData.h"


@interface RITasksController ()

@property (nonatomic, readonly) NSArray *data;

@property (nonatomic, readonly) UIImage *disabledImage;
@property (nonatomic, readonly) UIImage *enabledImage;

@end


@implementation RITasksController


#pragma mark Data management

- (RITask *)taskAtIndexPath:(NSIndexPath *)indexPath {
    RITask *object = _data[indexPath.row];
    return object;
}

- (void)saveOrder {
    NSInteger count = _data.count;
    for (RITask *task in _data) {
        [task setSort:(count + 100)];
        count--;
    }
    [self.coreData saveContext];
}

#pragma mark Settings

- (void)reloadData {
    _data = [self.coreData tasksForJob:_job];
}

- (void)setJob:(RIJob *)job {
    FAKFontAwesome *icon = [FAKFontAwesome circleIconWithSize:14];
    [icon addAttribute:NSForegroundColorAttributeName value:[RIConfig lightMainColor]];
    _enabledImage = [icon imageWithSize:CGSizeMake(26, 26)];
    
    icon = [FAKFontAwesome circleIconWithSize:14];
    [icon addAttribute:NSForegroundColorAttributeName value:[RIConfig dangerColor]];
    _disabledImage = [icon imageWithSize:CGSizeMake(26, 26)];
    
    _job = job;
    [self reloadData];
}

#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? ((_job.history.count > 0) ? 2 : 1) : _data.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0) ? NO : YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0) ? NO : YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return LUITranslate((section == 0) ? @"Action" : @"Tasks");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *identifier = @"runCell";
        RITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[RITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        
        if (indexPath.row == 0) {
            [cell.textLabel setText:LUITranslate(@"Run")];
            FAKFontAwesome *icon = [FAKFontAwesome playIconWithSize:20];
            [icon addAttribute:NSForegroundColorAttributeName value:[RIConfig mainColor]];
            [cell.imageView setImage:[UIImage imageWithStackedIcons:@[icon] imageSize:CGSizeMake(22, 22)]];
        }
        else {
            [cell.textLabel setText:LUITranslate(@"History")];
            FAKFontAwesome *icon = [FAKFontAwesome historyIconWithSize:20];
            [icon addAttribute:NSForegroundColorAttributeName value:[RIConfig mainColor]];
            [cell.imageView setImage:[UIImage imageWithStackedIcons:@[icon] imageSize:CGSizeMake(22, 22)]];
        }
        
        return cell;
    }
    else {
        static NSString *identifier = @"accountCell";
        RITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[RITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        
        RITask *object = _data[indexPath.row];
        [cell.textLabel setText:object.command];
        
        [cell.textLabel setTextColor:(object.enabled ? [RIConfig textColor] : [RIConfig infoTextColor])];
        if (object.enabled) {
            [cell.imageView setImage:_enabledImage];
        }
        else {
            [cell.imageView setImage:_disabledImage];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (editingStyle) {
        case UITableViewCellEditingStyleNone:
            
            break;
        case UITableViewCellEditingStyleDelete: {
            RIJob *object = _data[indexPath.row];
            [self.coreData.managedObjectContext deleteObject:object];
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

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_data];
    RITask *task = [arr objectAtIndex:sourceIndexPath.row];
    [arr removeObject:task];
    [arr insertObject:task atIndex:destinationIndexPath.row];
    _data = [arr copy];
    [self saveOrder];
}

#pragma mark Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


@end
