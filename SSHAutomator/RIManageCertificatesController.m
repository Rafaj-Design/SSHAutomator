//
//  RIManageCertificatesController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 18/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIManageCertificatesController.h"
#import "NSObject+CoreData.h"
#import "RITableViewCell.h"
#import "RICertificate.h"


@interface RIManageCertificatesController ()

@end


@implementation RIManageCertificatesController


#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 1 : self.data.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0) ? NO : YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? @"Uploader" : @"Certificates";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"certificateCell";
    RITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    if (indexPath.section == 0) {
        [cell.textLabel setText:@"Upload new certificate"];
        [cell.detailTextLabel setText:nil];
    }
    else {
        RICertificate *object = self.data[indexPath.row];
        [cell.textLabel setText:object.name];
        [cell.detailTextLabel setText:nil];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (editingStyle) {
        case UITableViewCellEditingStyleNone:
            
            break;
        case UITableViewCellEditingStyleDelete: {
            RICertificate *object = self.data[indexPath.row];
            [self.coreData.managedObjectContext deleteObject:object];
            [self.coreData saveContext];
            if (self.requiresReload) {
                self.requiresReload();
            }
            break;
        }
        case UITableViewCellEditingStyleInsert:
            
            break;
            
        default:
            break;
    }
}


@end
