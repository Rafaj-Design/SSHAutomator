//
//  RIAccount.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <CoreData/CoreData.h>

@class RIJob;

@interface RIAccount : NSManagedObject

@property (nonatomic, retain) NSString * certificate;
@property (nonatomic, retain) NSString * host;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * port;
@property (nonatomic, retain) NSString * user;
@property (nonatomic, retain) NSSet *jobs;
@end

@interface RIAccount (CoreDataGeneratedAccessors)

- (void)addJobsObject:(RIJob *)value;
- (void)removeJobsObject:(RIJob *)value;
- (void)addJobs:(NSSet *)values;
- (void)removeJobs:(NSSet *)values;

@end
