//
//  WBAMain.h
//
//  Created by Ondrej Rafaj on 01/02/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBAMacros.h"
#import "WBAEnums.h"


extern NSString *const WBATranslationDataHasBeenUpdatedNotification;
extern NSString *const WBATranslationDataTranslationBeenUpdatedNotification;


@class WBATranslationData, WBATranslations, WBASettings;

@interface WBAMain : NSObject


@property (nonatomic, readonly) WBATranslations *translations;
@property (nonatomic, readonly) WBASettings *settings;

@property (nonatomic, readonly) WBATranslationData *data;

@property (nonatomic, readonly) WBATranslationDataSourceOrigin dataSourceOrigin;   // Based on what start method has been used, could be default for wellbakedapp.com, custom for any custom URL you might uploaded the API files to or local only which only takes files from the bundle. Each variant requires bundle files to be present.
@property (nonatomic) WBADataType dataType;                             // Load iOS only keys or all keys, default is iOS only (which includes all platforms keys too!)

// Source is wellbakedapp.com (WBATranslationDataSourceOriginDefault)
@property (nonatomic) NSInteger applicationId;                          // ID of the application
@property (nonatomic) WBABuild buildType;                               // Use staging, live or define custom using for example "buildTranslationVersion", default is live

// Source is custom URL
@property (nonatomic, readonly) NSURL *customUrl;                        // Custom url that contains publicly available translation files

@property (nonatomic) NSInteger buildTranslationVersion;                // If "buildType" is set to custom, you can specify the exact version of translation to be used

@property (nonatomic, getter=isInDebugMode) BOOL debugMode;

+ (instancetype)sharedWBA;


- (void)startTranslationsWithBasicData:(WBATranslationData *)data andApplicationId:(NSInteger)applicationId;       // Use wellbakedapp.com as a source (WBATranslationDataSourceOriginDefault)
- (void)startTranslationsWithBasicData:(WBATranslationData *)data andCustomUrl:(NSURL *)url;                       // Use custom URL to host your API files (WBATranslationDataSourceOriginCustom)
- (void)startBasicData:(WBATranslationData *)data;                                                     // Use only locally bundled data (WBATranslationDataSourceOriginLocalOnly)


@end
