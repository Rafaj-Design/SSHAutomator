//
//  RIIconCollectionViewCell.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 20/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIIconCollectionViewCell.h"


@interface RIIconCollectionViewCell ()

@property (nonatomic, readonly) UIImageView *imageView;

@end


@implementation RIIconCollectionViewCell


#pragma mark Creating elements

- (void)createImageView {
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [_imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    [_imageView setClipsToBounds:YES];
    [self addSubview:_imageView];
}

- (void)createAllElements {
    [self createImageView];
}

#pragma mark Settings

- (void)setImage:(UIImage *)image {
    _image = image;
    [_imageView setImage:_image];
}

#pragma mark Initialization

- (void)setup {
    [self createAllElements];
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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


@end
