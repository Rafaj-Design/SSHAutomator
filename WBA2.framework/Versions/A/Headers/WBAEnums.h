//
//  WBAEnums.h
//
//  Created by Ondrej Rafaj on 01/02/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#ifndef WellBakedApp_WBAEnums_h
#define WellBakedApp_WBAEnums_h



typedef NS_ENUM(NSInteger, WBABuild) {
    WBABuildStaging,
    WBABuildLive,
    WBABuildCustom
};

typedef NS_ENUM(NSInteger, WBATranslationDataSourceOrigin) {
    WBATranslationDataSourceOriginDefault,
    WBATranslationDataSourceOriginCustom,
    WBATranslationDataSourceOriginLocalOnly
};

typedef NS_ENUM(NSInteger, WBADataType) {
    WBADataTypeiOSKeysOnly = 1,
    WBADataTypeAllKeys = 0
};

typedef NS_ENUM(NSInteger, WBACacheType) {
    WBACacheTypeTranslations,
    WBACacheTypeTranslationsInfo,
    WBACacheTypeImageTranslations,
    WBACacheTypeConfiguration,
    WBACacheTypeKillSwitch
};



#endif
