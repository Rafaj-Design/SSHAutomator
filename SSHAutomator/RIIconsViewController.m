//
//  RIIconsViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIIconsViewController.h"
#import <LUIFramework/LUIFramework.h>
#import "RICollectionView.h"
#import "RIIconsController.h"
#import "RIIconCollectionViewCell.h"


@interface RIIconsViewController () <UICollectionViewDelegate>

@property (nonatomic, readonly) RICollectionView *collectionView;
@property (nonatomic, readonly) RIIconsController *controller;

@end


@implementation RIIconsViewController


#pragma mark Creating elements

- (void)createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setSectionInset:UIEdgeInsetsMake(16, 10, 16, 10)];
    
    _collectionView = [[RICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [_collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_collectionView setDataSource:_controller];
    [_collectionView setDelegate:self];
    
    [_collectionView registerClass:[RIIconCollectionViewCell class] forCellWithReuseIdentifier:RIIconsControllerCellIdentifier];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:_collectionView];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createCollectionView];
}

#pragma mark Initialization

- (void)setup {
    [super setup];
    
    [self setTitle:LUITranslate(@"Select icon")];
    
    _controller = [[RIIconsController alloc] init];
}

#pragma mark Collection view data source methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (_didSelectIcon) {
        _didSelectIcon([_controller codeForIconAtIndexPath:indexPath]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
