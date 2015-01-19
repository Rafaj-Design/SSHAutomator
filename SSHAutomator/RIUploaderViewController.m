//
//  RIUploaderViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIUploaderViewController.h"
#import <Reachability/Reachability.h>
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "GCDWebServerFileResponse.h"
#import "GCDWebServerMultiPartFormRequest.h"
#include <ifaddrs.h>
#include <arpa/inet.h>


@interface RIUploaderViewController ()

@property (nonatomic, readonly) Reachability *reachability;
@property (nonatomic, readonly) GCDWebServer *webServer;

@property (nonatomic, readonly) UILabel *label;

@end


@implementation RIUploaderViewController


#pragma mark Creating elements

- (void)createUrlLabel {
    _label = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, (self.view.frame.size.width - 40), 60)];
    [_label setTextAlignment:NSTextAlignmentCenter];
    [_label setTextColor:[UIColor darkTextColor]];
    [_label setBackgroundColor:[UIColor clearColor]];
    [_label setNumberOfLines:5];
    [_label setLineBreakMode:NSLineBreakByWordWrapping];
    [self.view addSubview:_label];
    
    [self updateLabel];
}

- (void)createImacImage {
    UIImage *img = [UIImage imageNamed:@"upload-imac"];
    UIImageView *iv = [[UIImageView alloc] initWithImage:img];
    CGRect r = iv.frame;
    r.origin.x = ((self.view.frame.size.width - r.size.width) / 2);
    r.origin.y = 190;
    [iv setFrame:r];
    [self.view addSubview:iv];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"Upload"];
    
    [self createUrlLabel];
    [self createImacImage];
}

#pragma mark Settings

- (void)updateLabel {
    [_label setText:[NSString stringWithFormat:@"Visit http://%@:8888 in your web browser", [self getIPAddress]]];
}

#pragma mark Initialization

- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (void)setupWebServer {
    _reachability = [Reachability reachabilityForLocalWiFi];
    
    _webServer = [[GCDWebServer alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [_webServer addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"uploader-upload" ofType:@"html"];
        NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        return [GCDWebServerDataResponse responseWithHTML:html];
    }];
    
    [_webServer addHandlerForMethod:@"POST" path:@"/" requestClass:[GCDWebServerMultiPartFormRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request) {
        GCDWebServerMultiPartFile *file = [(GCDWebServerMultiPartFormRequest *)request firstFileForControlName:@"file"];
        if (file) {
            NSString *content = [NSString stringWithContentsOfFile:file.temporaryPath encoding:NSUTF8StringEncoding error:nil];
            if (content) {
                if (weakSelf.fileUploaded) {
                    weakSelf.fileUploaded(content, file.fileName);
                }
                
                NSString *path = [[NSBundle mainBundle] pathForResource:@"uploader-done" ofType:@"html"];
                NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                return [GCDWebServerDataResponse responseWithHTML:html];
            }
        }
        NSString *path = [[NSBundle mainBundle] pathForResource:@"uploader-upload" ofType:@"html"];
        NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        return [GCDWebServerDataResponse responseWithHTML:html];
    }];
    
    BOOL ok = [_webServer startWithPort:8888 bonjourName:nil];
    
    [_reachability setReachableBlock:^void (Reachability * reachability) {
        [weakSelf.webServer startWithPort:8888 bonjourName:nil];
        [weakSelf updateLabel];
    }];
    [_reachability setUnreachableBlock:^void (Reachability * reachability) {
        
    }];
    [self updateLabel];
    
    [_reachability startNotifier];
}

- (void)setup {
    [super setup];
    
    [self setupWebServer];
}

#pragma mark View lifecycle

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([_webServer isRunning]) {
        [_webServer stop];
    }
}


@end
