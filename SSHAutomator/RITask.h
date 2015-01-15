//
//  RITask.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <CoreData/CoreData.h>

@class RIJob;

@interface RITask : NSManagedObject

@property (nonatomic, retain) NSString * command;
@property (nonatomic) int16_t sort;
@property (nonatomic) BOOL enabled;
@property (nonatomic, retain) RIJob *job;

@end
