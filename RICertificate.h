//
//  RICertificate.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RIAccount;

@interface RICertificate : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *accounts;
@end

@interface RICertificate (CoreDataGeneratedAccessors)

- (void)addAccountsObject:(RIAccount *)value;
- (void)removeAccountsObject:(RIAccount *)value;
- (void)addAccounts:(NSSet *)values;
- (void)removeAccounts:(NSSet *)values;

@end
