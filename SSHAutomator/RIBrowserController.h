//
//  RIBrowserController.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 20/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RIAccount;

@interface RIBrowserController : NSObject <UITableViewDataSource>

@property (nonatomic, copy) void (^pathChanged)(NSString *path);
@property (nonatomic, copy) void (^fileSelected)(NSString *filePath);
@property (nonatomic, copy) void (^loginFailed)(NSError *error);
@property (nonatomic, copy) void (^requiresReload)();

@property (nonatomic, strong) RIAccount *account;
@property (nonatomic, strong) NSString *currentPath;

@property (nonatomic, readonly) NSArray *foldersData;
@property (nonatomic, readonly) NSArray *filesData;

- (NSDictionary *)fileAtIndexPath:(NSIndexPath *)indexPath;
- (NSDictionary *)folderAtIndexPath:(NSIndexPath *)indexPath;

- (void)goTo:(NSString *)folder;


@end
