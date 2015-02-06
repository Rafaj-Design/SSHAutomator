//
//  WBATranslations.h
//
//  Created by Ondrej Rafaj on 01/02/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBAEnums.h"


@class WBARegisteredElements;

@interface WBATranslations : NSObject

@property (nonatomic, copy) void (^didReceiveInfoFileResponse)(NSDictionary *data, NSError *error);
@property (nonatomic, copy) void (^didReceiveLocalizationFileResponse)(NSDictionary *data, NSError *error);

@property (nonatomic, strong) WBARegisteredElements *registeredElements;

+ (NSString *)get:(NSString *)key comment:(NSString *)comment;
+ (NSString *)get:(NSString *)key;

- (BOOL)isCachedData;
- (void)loadData;


@end
