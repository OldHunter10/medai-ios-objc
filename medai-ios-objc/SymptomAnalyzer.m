//
//  SymptomAnalyzer.m
//  medai-ios-objc
//
//  Created by JC on 2025/7/26.
//

#import "SymptomAnalyzer.h"

@implementation SymptomAnalyzer

+ (NSDictionary *)analyzeSymptomsFromText:(NSString *)text {
    // 读取本地 diagnosis_data.json
    NSString *path = [[NSBundle mainBundle] pathForResource:@"diagnosis_data" ofType:@"json"];
    if (!path) return @{};
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data) return @{};
    
    NSError *error = nil;
    NSDictionary *rawData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error || ![rawData isKindOfClass:[NSDictionary class]]) return @{};
    
    // 拆分输入的关键词（空格分隔）
    NSArray *inputKeywords = [[text lowercaseString] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableSet *foundConditions = [NSMutableSet set];
    NSMutableSet *foundDepartments = [NSMutableSet set];
    
    for (NSString *keyword in inputKeywords) {
        if (keyword.length == 0) continue;
        
        NSDictionary *entry = rawData[keyword];
        if (entry) {
            NSArray *conditions = entry[@"conditions"];
            NSArray *departments = entry[@"departments"];
            
            if ([conditions isKindOfClass:[NSArray class]]) {
                [foundConditions addObjectsFromArray:conditions];
            }
            if ([departments isKindOfClass:[NSArray class]]) {
                [foundDepartments addObjectsFromArray:departments];
            }
        }
    }
    
    return @{
        @"conditions": [foundConditions allObjects],
        @"departments": [foundDepartments allObjects]
    };
}

@end
