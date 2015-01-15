//
//  NSObject+CoreData.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "NSObject+CoreData.h"
#import "RIAppDelegate.h"


@implementation NSObject (CoreData)


#pragma mark Core data stuff

- (RICoreData *)coreData {
    RIAppDelegate *appDelegate = (RIAppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.coreData;
}


@end
