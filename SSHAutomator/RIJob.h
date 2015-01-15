//
//  RIJob.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <CoreData/CoreData.h>

@class RIAccount, RICertificate, RIHistory, RITask;

@interface RIJob : NSManagedObject

@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) NSInteger sort;
@property (nonatomic) int16_t repeat;
@property (nonatomic, retain) RIAccount *account;
@property (nonatomic, retain) NSSet *tasks;
@property (nonatomic, retain) NSSet *history;
@property (nonatomic, retain) RICertificate *certificate;
@end

@interface RIJob (CoreDataGeneratedAccessors)

- (void)addTasksObject:(RITask *)value;
- (void)removeTasksObject:(RITask *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

- (void)addHistoryObject:(RIHistory *)value;
- (void)removeHistoryObject:(RIHistory *)value;
- (void)addHistory:(NSSet *)values;
- (void)removeHistory:(NSSet *)values;

@end
