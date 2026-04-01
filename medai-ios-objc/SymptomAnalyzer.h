//
//  SymptomAnalyzer.h
//  medai-ios-objc
//
//  Created by JC on 2025/7/26.
//

#import <Foundation/Foundation.h>

@interface SymptomAnalyzer : NSObject

+ (NSDictionary *)analyzeSymptomsFromText:(NSString *)text;
+ (NSDictionary *)analyzeSymptomsFromText:(NSString *)text followUpAnswer:(nullable NSString *)followUpAnswer;

@end
