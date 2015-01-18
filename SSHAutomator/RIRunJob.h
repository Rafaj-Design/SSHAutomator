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

@property (nonatomic, copy) void (^logUpdated)(NSString *log);
@property (nonatomic, copy) void (^success)(NSString *log, NSTimeInterval connectionTime, NSTimeInterval executionTime);
@property (nonatomic, copy) void (^failure)(NSString *log, NSTimeInterval connectionTime, NSTimeInterval executionTime);

- (void)run:(RIJob *)job;


@end
