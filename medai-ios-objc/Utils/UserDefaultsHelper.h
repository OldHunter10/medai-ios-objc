//
//  UserDefaultsHelper.h
//  medai-ios-objc
//
//  Created by JC on 2025/9/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserDefaultsHelper : NSObject

+ (NSString *)stringForKey:(NSString *)key defaultValue:(nullable NSString *)defaultValue;
+ (void)setString:(NSString *)value forKey:(NSString *)key;

+ (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
+ (void)setBool:(BOOL)value forKey:(NSString *)key;

+ (void)removeValueForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
