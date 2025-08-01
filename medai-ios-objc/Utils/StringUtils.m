//
//  StringUtils.m
//  medai-ios-objc
//
//  Created by JC on 2025/8/1.
//

#import "StringUtils.h"

@implementation StringUtils
+ (NSArray<NSString *> *)splitSymptomText:(NSString *)input {
    NSString *trimmed = [input lowercaseString];
    NSArray *components = [trimmed componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
}
@end
