//
//  RIIconsController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 20/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIIconsController.h"
#import <FontAwesomeKit/FAKFontAwesome.h>
#import "RIIconCollectionViewCell.h"


@interface RIIconsController ()

@property (nonatomic, readonly) NSArray *data;

@end


@implementation RIIconsController

NSString *const RIIconsControllerCellIdentifier = @"RIIconsControllerCellIdentifier";


#pragma mark Data handling

- (NSString *)codeForIconAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    if (index > 0) {
        index--;
        return _data[index];
    }
    else {
        return nil;
    }
}

#pragma mark Initialization

- (void)setup {
    _data = [FAKFontAwesome allIcons].allKeys;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark Collection view data source methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (_data.count + 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RIIconCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RIIconsControllerCellIdentifier forIndexPath:indexPath];
    NSInteger index = indexPath.row;
    if (index > 0) {
        index--;
        NSString *code = _data[index];
        FAKFontAwesome *icon = [FAKFontAwesome iconWithCode:code size:30];
        [cell setImage:[UIImage imageWithStackedIcons:@[icon] imageSize:CGSizeMake(90, 90)]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat side = 50;
    return CGSizeMake(side, side);
}


@end
