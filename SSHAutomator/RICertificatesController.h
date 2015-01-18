//
//  RICertificatesController.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RICertificate;

@interface RICertificatesController : NSObject <UITableViewDataSource>

@property (nonatomic, copy) void (^requiresReload)();
@property (nonatomic, readonly) NSArray *data;


- (RICertificate *)certificateAtIndexPath:(NSIndexPath *)indexPath;
- (RICertificate *)certificateAtIndex:(NSInteger)index;
- (NSArray *)certificates;

- (void)reloadData;


@end
