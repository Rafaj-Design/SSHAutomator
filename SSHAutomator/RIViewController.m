//
//  ViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIViewController.h"
#import <LUIFramework/LUIFramework.h>
#import "RIConfig.h"


@interface RIViewController () <UITableViewDelegate>

@end


@implementation RIViewController


#pragma mark Creating elements

- (void)createAllElements {
    [self.view setBackgroundColor:[RIConfig tableBackgroundColor]];
}

#pragma mark View lifecycle

- (void)loadView {
    [super loadView];
    
    [self createAllElements];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark Initialization

- (void)setup {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Table view delegate methods

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LUITranslate(@"Delete");
}


@end
