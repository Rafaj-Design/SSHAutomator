//
//  RISelectCertificateViewController.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 18/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIViewController.h"


@class RICertificate;

@interface RISelectCertificateViewController : RIViewController

@property (nonatomic, copy) void (^didSelectCertificate)(RICertificate *certificate);


@end
