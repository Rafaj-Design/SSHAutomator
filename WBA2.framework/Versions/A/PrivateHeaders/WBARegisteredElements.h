//
//  WBARegisteredElements.h
//
//  Created by Ondrej Rafaj on 06/02/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <TargetConditionals.h>

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

#elif TARGET_OS_MAC

#import <Cocoa/Cocoa.h>

#endif


@interface WBARegisteredElements : NSObject

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE

- (void)registerLabel:(UILabel *)label forKey:(NSString *)key;
- (void)registerViewController:(UIViewController *)controller forKey:(NSString *)key;
- (void)registerButton:(UIButton *)button forKey:(NSString *)key;
- (void)registerTextField:(UITextField *)textField forKey:(NSString *)key;
- (void)registerTextView:(UITextView *)textView forKey:(NSString *)key;
- (void)registerSearchBar:(UISearchBar *)searchBar forKey:(NSString *)key;
- (void)registerBarItem:(UIBarItem *)barItem forKey:(NSString *)key;

#elif TARGET_OS_MAC
#endif

- (void)reloadRegisteredComponents;


@end
