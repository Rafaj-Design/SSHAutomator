//
//  WBACache.h
//
//  Created by Ondrej Rafaj on 05/02/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBAEnums.h"


@interface WBACache : NSObject

+ (void)saveData:(NSDictionary *)data forProduct:(WBACacheType)product;
+ (NSDictionary *)dataForProduct:(WBACacheType)product;
+ (BOOL)isCachedDataForProduct:(WBACacheType)product;




@end
