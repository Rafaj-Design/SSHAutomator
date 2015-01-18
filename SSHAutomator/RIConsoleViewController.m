//
//  RIConsoleViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIConsoleViewController.h"
#import "RIHistory.h"
#import "RIRunJob.h"


@interface RIConsoleViewController ()

@property (nonatomic, readonly) UITextView *textView;

@end


@implementation RIConsoleViewController


#pragma mark Creating elements

- (void)createConsoleView {
    _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    [_textView setEditable:NO];
    [_textView setFont:[UIFont fontWithName:@"Courier" size:10]];
    [_textView setTextColor:[UIColor greenColor]];
    [_textView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_textView];
    
    if (_history) {
        [_textView setText:_history.log];
    }
}

- (void)createAllElements {
    [super createAllElements];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self setTitle:@"Log"];
    
    [self createConsoleView];
}

#pragma mark Settings

- (void)executeJob:(RIJob *)job {
    __typeof(self) __weak weakSelf = self;
    RIRunJob *executor = [[RIRunJob alloc] init];
    [executor setSuccess:^(NSString *log, NSTimeInterval connectionTime, NSTimeInterval executionTime) {
        [weakSelf.textView setText:log];
    }];
    [executor setFailure:^(NSString *log, NSTimeInterval connectionTime, NSTimeInterval executionTime) {
        [weakSelf.textView setText:log];
    }];
    [executor run:job];
}

- (void)setHistory:(RIHistory *)history {
    _history = history;
    [_textView setText:_history.log];
}


@end
