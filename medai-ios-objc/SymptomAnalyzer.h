//
//  SymptomAnalyzer.h
//  medai-ios-objc
//
//  Created by JC on 2025/7/26.
//

#import <Foundation/Foundation.h>

@interface SymptomAnalyzer : NSObject

// 从字符串中分析症状 返回结果字典（conditions departments）
+ (NSDictionary *)analyzeSymptomsFromText:(NSString *)text;

@end
