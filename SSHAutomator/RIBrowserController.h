//
//  RIBrowserController.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 20/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NMSSHSession, RIAccount, DLSFTPFile;

@interface RIBrowserController : NSObject <UITableViewDataSource>

@property (nonatomic, readonly) NMSSHSession *session;

@property (nonatomic, copy) void (^pathChanged)(NSString *path);
@property (nonatomic, copy) void (^pathSelected)(NSString *path);
@property (nonatomic, copy) void (^loginFailed)(NSError *error);
@property (nonatomic, copy) void (^failure)(NSError *error);
@property (nonatomic, copy) void (^requiresReload)();

@property (nonatomic, strong) RIAccount *account;
@property (nonatomic, strong) NSString *currentPath;

- (DLSFTPFile *)fileAtIndexPath:(NSIndexPath *)indexPath;

- (void)goTo:(NSString *)folder;
- (void)reloadData;


@end
