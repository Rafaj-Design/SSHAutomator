//
//  RIRunTask.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


@class RIJob;

@interface RIRunJob : NSObject

+ (void)run:(RIJob *)job;


@end
