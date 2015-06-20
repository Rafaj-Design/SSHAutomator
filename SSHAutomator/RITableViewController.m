//
//  RITableViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RITableViewController.h"
#import <LUIFramework/LUIFramework.h>
#import "RIConfig.h"


@interface RITableViewController () <UITableViewDelegate>

@end


@implementation RITableViewController


#pragma mark Creating elements

- (void)createAllElements {
    [self.tableView setBackgroundColor:[RIConfig tableBackgroundColor]];
}

#pragma mark View lifecycle

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    [self createAllElements];
//}

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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
