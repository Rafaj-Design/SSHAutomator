//
//  AppDelegate.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIAppDelegate.h"
#import <Crashlytics/Crashlytics.h>
#import <FontAwesomeKit/FAKFontAwesome.h>
#import <WBA2/WBA2.h>
#import "RIAccountsViewController.h"
#import "RILinuxCommandsViewController.h"
#import "RIConfig.h"


@interface RIAppDelegate ()

@end


@implementation RIAppDelegate


#pragma mark Helper methods

- (UINavigationController *)tabBarElementWithIcon:(FAKFontAwesome *)icon andController:(UIViewController *)controller {
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:controller];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]];
    [nc.tabBarItem setImage:[[icon imageWithSize:CGSizeMake(22, 22)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [icon addAttribute:NSForegroundColorAttributeName value:[RIConfig mainColor]];
    [nc.tabBarItem setSelectedImage:[[icon imageWithSize:CGSizeMake(22, 22)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    return nc;
}

#pragma mark Application delegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Crashlytics
    [Crashlytics startWithAPIKey:@"fdad57f5fd93d14410334446675bff03d3a3f996"];
    
    // Core Data
    _coreData = [[RICoreData alloc] init];
    
    
    
    
    
    
    
    
    
    
    
    // WellBakedApp
    
    [[WBAMain sharedWBA].translations setDidReceiveInfoFileResponse:^(NSDictionary *data, NSError *error) {
        NSLog(@"Info: %@ - %@", data, error.localizedDescription);
    }];
    [[WBAMain sharedWBA].translations setDidReceiveLocalizationFileResponse:^(NSDictionary *data, NSError *error) {
        NSLog(@"Localization: %@ - %@", data, error.localizedDescription);
    }];
    
    WBATranslationData *basicData = [[WBATranslationData alloc] initWithBundledWBALocalizationFileNamed:@"full.json" withDefaultLanguageCode:@"de"];
    [[WBAMain sharedWBA] startTranslationsWithBasicData:basicData andCustomUrl:[NSURL URLWithString:@"http://api.wba2.com/1.0/2/2/"]];
    
    //[[WBAMain sharedWBA] setDebugMode:YES];
    
    NSLog(@"Translations: %@", [WBAMain sharedWBA].data.translations);
    
    
    
    
    
    
    
    
    
    // Appearance
    [[UINavigationBar appearance] setBarTintColor:[RIConfig mainColor]];
    [[UINavigationBar appearance] setTintColor:[RIConfig lightTextColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [RIConfig lightTextColor], NSFontAttributeName: [RIConfig systemFontOfSize:20]}];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName: [RIConfig lightTextColor], NSFontAttributeName: [RIConfig systemFontOfSize:16]} forState:UIControlStateNormal];
    [[UITabBar appearance] setTintColor:[RIConfig mainColor]];
    [[UITableViewCell appearance] setTintColor:[RIConfig mainColor]];
    
    FAKFontAwesome *icon = [FAKFontAwesome databaseIconWithSize:20];
    UINavigationController *accountsNavigationController = [self tabBarElementWithIcon:icon andController:[[RIAccountsViewController alloc] init]];
    
    icon = [FAKFontAwesome terminalIconWithSize:20];
    UINavigationController *commandsNavigationController = [self tabBarElementWithIcon:icon andController:[[RILinuxCommandsViewController alloc] init]];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[accountsNavigationController, commandsNavigationController]];
    
    [_window setRootViewController:tabBarController];
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
