//
//  RIHistory.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <CoreData/CoreData.h>

@class RIJob;

@interface RIHistory : NSManagedObject

@property (nonatomic, retain) NSString * log;
@property (nonatomic) NSTimeInterval date;
@property (nonatomic) int16_t loginTime;
@property (nonatomic) int16_t executionTime;
@property (nonatomic, retain) RIJob *job;

@end
