//
//  RIRunTask.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIRunJob.h"
#import <NMSSH/NMSSH.h>
#import "NSObject+CoreData.h"


@interface RIRunJob () <NMSSHSessionDelegate>

@property (nonatomic, readonly) NMSSHSession *session;

@property (nonatomic, readonly) RIAccount *account;
@property (nonatomic, readonly) RIJob *job;
@property (nonatomic, readonly) NSArray *tasks;

@property (nonatomic, readonly) NSString *log;

@property (nonatomic, readonly) NSDate *startDate;
@property (nonatomic, readonly) NSTimeInterval connectionTime;
@property (nonatomic, readonly) NSTimeInterval executionTime;

@end


@implementation RIRunJob


#pragma mark Loggings

- (void)log:(NSString *)log {
    if (!log) {
        _log = [_log stringByAppendingString:@"\n"];
    }
    else {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm:ss:SSS"];
        NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
        
        if (!_log) {
            _log = @"";
        }
        
        NSLog(@"%@ - %@", dateString, log);
        
        _log = [_log stringByAppendingFormat:@"%@: %@\n", dateString, log];
        
        [self logUpdated];
    }
}

#pragma mark Blocks

- (void)doLogUpdated {
    if (_logUpdated) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            _logUpdated(_log);
        });
    }
}

- (void)doSuccess {
    if (_success) {
        _executionTime = [[NSDate date] timeIntervalSinceDate:_startDate];
        [self log:[NSString stringWithFormat:@"Execution time: %f", _executionTime]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            _success(_log, _connectionTime, _executionTime);
        });
    }
}

- (void)doFailure {
    if (_failure) {
        _executionTime = [[NSDate date] timeIntervalSinceDate:_startDate];
        [self log:[NSString stringWithFormat:@"Execution time: %f", _executionTime]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            RIHistory *history = [self.coreData newHistoryForJob:_job];
            [history setDate:[NSDate date]];
            [history setLog:_log];
            [self.coreData saveContext];
            
            _failure(_log, _connectionTime, _executionTime);
        });
    }
}

#pragma mark Settings

- (void)run:(RIJob *)job {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _job = job;
        _account = job.account;
        _tasks = [self.coreData tasksForJob:_job];
        
        _startDate = [NSDate date];
        
        [self log:@"Session started"];
        [self log:[NSString stringWithFormat:@"Connecting to: %@@%@:%@", _account.user, _account.host, _account.port]];
        _session = [NMSSHSession connectToHost:_account.host port:_account.port.intValue withUsername:_account.user];
        [_session setDelegate:self];
        if (_session.isConnected) {
            
            _connectionTime = [[NSDate date] timeIntervalSinceDate:_startDate];
            [self log:[NSString stringWithFormat:@"Connection time: %f", _connectionTime]];
            _startDate = [NSDate date]; // Reset timer for execution
            if (_account.certificate) {
                [_session authenticateByPublicKey:nil privateKey:_account.certificate.content andPassword:nil];
            }
            else {
                [_session authenticateByPassword:_account.password];
            }
            if (_session.isAuthorized) {
                [self log:@"Authentication succeeded"];
                NSString *command = @"";
                for (RITask *task in _tasks) {
                    command = [command stringByAppendingFormat:@"%@\n", task.command];
                }
                NSError *error = nil;
                [self log:command];
                NSString *response = [_session.channel execute:command error:&error];
                if (!error) {
                    [self log:response];
                    [self log:@"Job succeeded"];
                    
                    [self doSuccess];
                }
                else {
                    [self log:error.localizedDescription];
                    [self log:@"Job failed"];
                    [self doFailure];
                }
                [self log:nil];
                
                _logUpdated = nil;
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    RIHistory *history = [self.coreData newHistoryForJob:_job];
                    [history setCommand:command];
                    [history setLog:_log];
                    [self.coreData saveContext];
                });
                return;
            }
            else {
                _logUpdated = nil;
                [self log:@"Authentication failed"];
                [self doFailure];
            }
            [_session disconnect];
        }
        else {
            _logUpdated = nil;
            [self log:@"Connection failed"];
            [self doFailure];
        }
    });
}

#pragma mark Session delegate methods

- (void)session:(NMSSHSession *)session didDisconnectWithError:(NSError *)error {
    _logUpdated = nil;
    [self log:[NSString stringWithFormat:@"Disconnected with error: %@", error.localizedDescription]];
    [self doFailure];
}


@end
