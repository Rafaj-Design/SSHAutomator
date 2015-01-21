//
//  RIIconsController.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 20/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *const RIIconsControllerCellIdentifier;

@interface RIIconsController : NSObject <UICollectionViewDataSource>

- (NSString *)codeForIconAtIndexPath:(NSIndexPath *)indexPath;


@end
