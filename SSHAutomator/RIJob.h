//
//  RIJob.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RIAccount, RIHistory, RITask;

@interface RIJob : NSManagedObject

@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) int16_t repeat;
@property (nonatomic) int16_t sort;
@property (nonatomic, retain) RIAccount *account;
@property (nonatomic, retain) NSSet *history;
@property (nonatomic, retain) NSSet *tasks;
@end

@interface RIJob (CoreDataGeneratedAccessors)

- (void)addHistoryObject:(RIHistory *)value;
- (void)removeHistoryObject:(RIHistory *)value;
- (void)addHistory:(NSSet *)values;
- (void)removeHistory:(NSSet *)values;

- (void)addTasksObject:(RITask *)value;
- (void)removeTasksObject:(RITask *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end
