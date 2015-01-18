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


@interface RIUploaderViewController ()

@property (nonatomic, readonly) Reachability *reachability;
@property (nonatomic, readonly) GCDWebServer *webServer;

@property (nonatomic, readonly) UILabel *label;

@end


@implementation RIUploaderViewController


#pragma mark Creating elements

- (void)createUrlLabel {
    _label = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, (self.view.frame.size.width - 40), 40)];
    [_label setTextAlignment:NSTextAlignmentCenter];
    [_label setTextColor:[UIColor darkTextColor]];
    [_label setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_label];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"Upload"];
    
    [self createUrlLabel];
}

#pragma mark Initialization

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
    
    [weakSelf.webServer startWithPort:8888 bonjourName:nil];
    
    [_reachability setReachableBlock:^void (Reachability * reachability) {
        [weakSelf.webServer startWithPort:8888 bonjourName:nil];
        NSLog(@"Visit %@ in your web browser", weakSelf.webServer.serverURL);
        [weakSelf.label setText:[NSString stringWithFormat:@"Visit %@ in your web browser", weakSelf.webServer.serverURL.absoluteString]];
    }];
    [_reachability setUnreachableBlock:^void (Reachability * reachability) {
        
    }];
    NSLog(@"Visit %@ in your web browser", _webServer.serverURL);
    [_label setText:[NSString stringWithFormat:@"Visit %@ in your web browser", _webServer.serverURL.absoluteString]];
    
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
