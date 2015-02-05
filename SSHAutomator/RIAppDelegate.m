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
//#import <WellBakedApp/WellBakedApp.h>
#import "RIAccountsViewController.h"
#import "RILinuxCommandsViewController.h"
#import "RIConfig.h"

#import "WBAMain.h"
#import "WBAData.h"
#import "WBATranslations.h"
#import "WBACache.h"


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
    NSDictionary *translations;
    if ([[WBAMain sharedWBA].translations isCachedData]) {
        translations = [WBACache dataForProduct:WBACacheTypeTranslations];
    }
    else {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"WBA/full" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *err = nil;
        translations = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        NSAssert1((err == nil), @"Basic localization loading failed: %@", err.localizedDescription);
    }
    
    WBAData *basicData = [[WBAData alloc] init];
    [basicData setTranslations:translations];
    [basicData setDefaultLanguageCode:@"en"];
    
    [[WBAMain sharedWBA].translations setDidReceiveInfoFileResponse:^(NSDictionary *data, NSError *error) {
        NSLog(@"Info: %@ - %@", data, error.localizedDescription);
    }];
    [[WBAMain sharedWBA].translations setDidReceiveLocalizationFileResponse:^(NSDictionary *data, NSError *error) {
        NSLog(@"Localization: %@ - %@", data, error.localizedDescription);
    }];
    [[WBAMain sharedWBA] startWithBasicData:basicData andCustomUrl:[NSURL URLWithString:@"http://s3.amazonaws.com/admin.wellbakedapp.com/API_1.0/2/live/"]];
    
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
