//
//  RiCoreData.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RICoreData.h"


@interface RICoreData () <CDEPersistentStoreEnsembleDelegate>

@property (nonatomic, readonly) CDEICloudFileSystem *cloudFileSystem;
@property (nonatomic, readonly) CDEPersistentStoreEnsemble *ensemble;

@property (nonatomic, readonly) NSURL *modelURL;
@property (nonatomic, readonly) NSURL *storeURL;

@end


@implementation RICoreData

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _modelURL = [[NSBundle mainBundle] URLForResource:@"SSHAutomator" withExtension:@"momd"];
        _storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SSHAutomator.sqlite"];
    }
    return self;
}

- (NSArray<NSString *> *)uniqueStrings:(NSArray<NSString *>)array {
    NSMutableArray *temp = [NSMutableArray array];
    for (NSString *string in array) {
        if ([temp containsObject:string]) {
            [temp addObject:string];
            
        }
    }
    return [temp copy];
}

#pragma mark Ensemble

- (void)setupCloudSync {
    _cloudFileSystem = [[CDEICloudFileSystem alloc] initWithUbiquityContainerIdentifier:@"6UPNZ3ACG2.com.ridiculous-innovations.SSHAutomator"];
    //_cloudFileSystem = [[CDEICloudFileSystem alloc] initWithUbiquityContainerIdentifier:@"iCloud.com.ridiculous-innovations.SSHAutomator"];
    _ensemble = [[CDEPersistentStoreEnsemble alloc] initWithEnsembleIdentifier:@"MainStore" persistentStoreURL:_storeURL managedObjectModelURL:_modelURL cloudFileSystem:_cloudFileSystem];
    [_ensemble setDelegate:self];
    
    [self checkLeech];
}

- (void)checkLeech {
    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    if (ubiq) {
        NSLog(@"iCloud access at %@", ubiq);
    }
    else {
        NSLog(@"No iCloud access");
    }
    
    if (!_ensemble.isLeeched) {
        [_ensemble leechPersistentStoreWithCompletion:^(NSError *error) {
            if (error) NSLog(@"Could not leech to ensemble: %@", error);
        }];
    }
    [_ensemble mergeWithCompletion:^(NSError *error) {
        if (error) NSLog(@"Error merging: %@", error);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(icloudDidDownload:) name:CDEICloudFileSystemDidDownloadFilesNotification object:nil];
}

- (void)icloudDidDownload:(NSNotification *)notification {
    [self syncWithCloud];
}

- (void)syncWithCloud {
    [self checkLeech];
    [_ensemble mergeWithCompletion:^(NSError *error) {
        if (error) NSLog(@"Error merging: %@", error);
    }];
}

#pragma mark Accounts

- (RIAccount *)newAccount {
    RIAccount *object = [NSEntityDescription insertNewObjectForEntityForName:@"Accounts" inManagedObjectContext:self.managedObjectContext];
    return object;
}

- (NSArray *)accounts {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort]];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        return nil;
    }
    else {
        return result;
    }
}

#pragma mark Jobs

- (RIJob *)newJobForAccount:(RIAccount *)account {
    RIJob *object = [NSEntityDescription insertNewObjectForEntityForName:@"Jobs" inManagedObjectContext:self.managedObjectContext];
    [object setAccount:account];
    return object;
}

- (NSArray *)jobsForAccount:(RIAccount *)account {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Jobs" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"account == %@", account]];

    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort]];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        return nil;
    }
    else {
        return result;
    }
}

#pragma mark Tasks

- (RITask *)newTaskForJob:(RIJob *)job {
    RITask *object = [NSEntityDescription insertNewObjectForEntityForName:@"Tasks" inManagedObjectContext:self.managedObjectContext];
    [object setJob:job];
    return object;
}

- (NSArray *)tasksForJob:(RIJob *)job {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tasks" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"job == %@", job]];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"sort" ascending:NO];
    [fetchRequest setSortDescriptors:@[sort]];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        return nil;
    }
    else {
        return result;
    }
}

#pragma mark History

- (RIHistory *)newHistoryForJob:(RIJob *)job {
    RIHistory *object = [NSEntityDescription insertNewObjectForEntityForName:@"History" inManagedObjectContext:self.managedObjectContext];
    [object setDate:[NSDate date]];
    [object setJob:job];
    return object;
}

- (NSArray *)historyForJob:(RIJob *)job {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"History" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"job == %@", job]];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:@[sort]];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        return nil;
    }
    else {
        return result;
    }
}

- (void)clearHistoryForJob:(RIJob *)job {
    NSArray *arr = [self historyForJob:job];
    for (RIHistory *h in arr) {
        [self.managedObjectContext deleteObject:h];
    }
    [self saveContext];
}

#pragma mark Certificates

- (RICertificate *)newCertificate {
    RICertificate *object = [NSEntityDescription insertNewObjectForEntityForName:@"Certificates" inManagedObjectContext:self.managedObjectContext];
    return object;
}

- (NSArray *)certificates {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Certificates" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort]];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        return nil;
    }
    else {
        return result;
    }
}

#pragma mark Core Data stack

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:_modelURL];
    [self setupCloudSync];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:_storeURL options:nil error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
