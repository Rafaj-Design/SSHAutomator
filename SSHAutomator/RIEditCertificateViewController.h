//
//  RIEditCertificateViewController.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 17/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RITableViewController.h"


@class RICertificate;

@interface RIEditCertificateViewController : RITableViewController

@property (nonatomic, copy) void (^dismissController)(RIEditCertificateViewController *controller, RICertificate *certificate);

@property (nonatomic, strong) RICertificate *certificate;


@end
