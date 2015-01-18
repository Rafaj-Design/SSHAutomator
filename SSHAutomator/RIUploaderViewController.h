//
//  RIUploaderViewController.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIViewController.h"


@interface RIUploaderViewController : RIViewController

@property (nonatomic, copy) void (^fileUploaded)(NSString *fileContent, NSString *fileName);


@end
