//
//  WBATranslationData.h
//
//  Created by Ondrej Rafaj on 01/02/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WBATranslationData : NSObject

@property (nonatomic, strong) NSString *defaultLanguageCode;
@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, strong) NSDictionary *translations;

- (instancetype)initWithBundledWBALocalizationFileNamed:(NSString *)fileName withDefaultLanguageCode:(NSString *)code;


@end
