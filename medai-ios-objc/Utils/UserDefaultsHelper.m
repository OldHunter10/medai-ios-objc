//
//  UserDefaultsHelper.m
//  medai-ios-objc
//
//  Created by JC on 2025/9/16.
//

#import "UserDefaultsHelper.h"

@implementation UserDefaultsHelper

+ (NSString *)stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    return value ?: defaultValue;
}

+ (void)setString:(NSString *)value forKey:(NSString *)key {
    if (value) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key] == nil) {
        return defaultValue;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeValueForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
