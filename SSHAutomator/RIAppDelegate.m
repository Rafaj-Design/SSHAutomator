//
//  AppDelegate.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIAppDelegate.h"
#import <Crashlytics/Crashlytics.h>
#import "RIAccountsViewController.h"
#import "RIConfig.h"


@interface RIAppDelegate ()

@end


@implementation RIAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Crashlytics
    [Crashlytics startWithAPIKey:@"fdad57f5fd93d14410334446675bff03d3a3f996"];
    
    // Core Data
    _coreData = [[RICoreData alloc] init];
    
    // Appearance
    [[UINavigationBar appearance] setBarTintColor:[RIConfig mainColor]];
    [[UINavigationBar appearance] setTintColor:[RIConfig lightTextColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [RIConfig lightTextColor], NSFontAttributeName: [RIConfig systemFontOfSize:20]}];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName: [RIConfig lightTextColor], NSFontAttributeName: [RIConfig systemFontOfSize:16]} forState:UIControlStateNormal];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:[[RIAccountsViewController alloc] init]];
    [_window setRootViewController:nc];
    [_window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [_coreData saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [_coreData saveContext];
}


@end
