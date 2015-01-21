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


@interface RIRunJob () <NMSSHSessionDelegate, NMSSHChannelDelegate>

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
        
        [self doLogUpdated];
    }
}

#pragma mark Blocks

- (void)doLogUpdated {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if (_logUpdated) {
            _logUpdated(_log);
        }
    });
}

- (void)doSuccess {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if (_success) {
            _executionTime = [[NSDate date] timeIntervalSinceDate:_startDate];
            [self log:[NSString stringWithFormat:@"Execution time: %f", _executionTime]];
            
            [self removeTemporaryKeyFile];
            
            _success(_log, _connectionTime, _executionTime);
        }
    });
}

- (void)doFailure {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if (_failure) {
            _executionTime = [[NSDate date] timeIntervalSinceDate:_startDate];
            [self log:[NSString stringWithFormat:@"Execution time: %f", _executionTime]];
            
            [self removeTemporaryKeyFile];
            
            RIHistory *history = [self.coreData newHistoryForJob:_job];
            [history setDate:[NSDate date]];
            [history setLog:_log];
            [self.coreData saveContext];
            
            _failure(_log, _connectionTime, _executionTime);
        }
    });
}

#pragma mark Settings

- (void)removeTemporaryKeyFile {
    NSString *path = [self keyPath];
    NSFileManager *m = [NSFileManager defaultManager];
    [m removeItemAtPath:path error:nil];
}

- (NSString *)keyPath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"key.pem"];
    return path;
}

- (void)run:(RIJob *)job {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _job = job;
        _account = job.account;
        _tasks = [self.coreData tasksForJob:_job];
        
        _startDate = [NSDate date];
        
        [self log:@"Session started"];
        [self log:[NSString stringWithFormat:@"Connecting to: %@@%@ port %@", _account.user, _account.host, _account.port]];
        _session = [NMSSHSession connectToHost:_account.host port:_account.port.intValue withUsername:_account.user];
        [_session setDelegate:self];
        if (_session.isConnected) {
            _connectionTime = [[NSDate date] timeIntervalSinceDate:_startDate];
            [self log:[NSString stringWithFormat:@"Connection time: %f", _connectionTime]];
            _startDate = [NSDate date]; // Reset timer for execution
            if (_account.certificate) {
                NSString *path = [self keyPath];
                [_account.certificate.content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
                [_session authenticateByPublicKey:nil privateKey:path andPassword:_account.password];
            }
            else {
                [_session authenticateByPassword:_account.password];
            }
            if (_session.isAuthorized) {
                [self log:@"Authentication succeeded"];
                
                NSError *shellError = nil;
                [_session.channel startShell:&shellError];
                [_session.channel setDelegate:self];
                [_session.channel setRequestPty:YES];
                if(!shellError) {
                    [self log:@"Started Shell"];
                    [self log:nil];
                    [self log:nil];
                    BOOL ok = YES;
                    for (RITask *task in _tasks) {
                        if (task.enabled) {
                            NSError *err = nil;
                            [self log:task.command];
                            NSString *response = [_session.channel execute:[NSString stringWithFormat:@"%@\n", task.command] error:&err];
                            if (response && response.length > 0) [self log:response];
                            if (err) {
                                ok = NO;
                                [self log:err.localizedDescription];
                                break;
                            }
                            [self log:nil];
                        }
                    }
                    if (ok) {
                        //[_session.channel closeShell];
                        [self log:@"Job succeeded"];
                        [self doSuccess];
                    }
                    else {
                        [self log:@"Job failed"];
                        [self doFailure];
                    }
                }
                else {
                    [self log:shellError.localizedDescription];
                    [self log:@"Job failed"];
                    [self doFailure];
                }
                
                [self log:nil];
                
                _logUpdated = nil;
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    RIHistory *history = [self.coreData newHistoryForJob:_job];
                    [history setLog:_log];
                    [self.coreData saveContext];
                });
            }
            else {
                _logUpdated = nil;
                [self log:@"Authentication failed"];
                [self doFailure];
            }
            //[_session disconnect];
        }
        else {
            _logUpdated = nil;
            [self log:@"Connection failed"];
            [self doFailure];
        }
    });
}

#pragma mark Channel delegate methods

- (void)channel:(NMSSHChannel *)channel didReadData:(NSString *)message {
    [self log:message];
}

- (void)channel:(NMSSHChannel *)channel didReadError:(NSString *)error {
    [self log:error];
}

#pragma mark Session delegate methods

- (void)session:(NMSSHSession *)session didDisconnectWithError:(NSError *)error {
    _logUpdated = nil;
    [self log:[NSString stringWithFormat:@"Disconnected with error: %@", error.localizedDescription]];
    [self doFailure];
}


@end
