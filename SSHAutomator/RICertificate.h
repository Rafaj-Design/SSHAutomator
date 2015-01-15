//
//  RICertificate.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <CoreData/CoreData.h>

@class RIJob;

@interface RICertificate : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSSet *jobs;
@end

@interface RICertificate (CoreDataGeneratedAccessors)

- (void)addJobsObject:(RIJob *)value;
- (void)removeJobsObject:(RIJob *)value;
- (void)addJobs:(NSSet *)values;
- (void)removeJobs:(NSSet *)values;

@end
