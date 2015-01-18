//
//  RIHistory.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 18/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RIJob;

@interface RIHistory : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * executionTime;
@property (nonatomic, retain) NSString * log;
@property (nonatomic, retain) NSNumber * loginTime;
@property (nonatomic, retain) NSString * command;
@property (nonatomic, retain) RIJob *job;

@end
