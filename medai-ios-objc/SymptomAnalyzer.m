//
//  SymptomAnalyzer.m
//  medai-ios-objc
//
//  Created by JC on 2025/7/26.
//

#import "SymptomAnalyzer.h"
#import "TriageRuleEngine.h"
#import "UserDefaultsHelper.h"
#import "Constants.h"

@implementation SymptomAnalyzer

+ (NSDictionary *)analyzeSymptomsFromText:(NSString *)text {
    return [self analyzeSymptomsFromText:text followUpAnswer:nil];
}

+ (NSDictionary *)analyzeSymptomsFromText:(NSString *)text followUpAnswer:(NSString *)followUpAnswer {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"diagnosis_data" ofType:@"json"];
    if (!path) return @{
        @"conditions": @[],
        @"departments": @[],
        @"risk_level": @"clinic_soon",
        @"next_step": @"Local data is missing. Please seek clinician support.",
        @"matched_rules": @[],
        @"needs_follow_up": @NO
    };

    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data) return @{
        @"conditions": @[],
        @"departments": @[],
        @"risk_level": @"clinic_soon",
        @"next_step": @"Local data is missing. Please seek clinician support.",
        @"matched_rules": @[],
        @"needs_follow_up": @NO
    };

    NSError *error = nil;
    NSDictionary *rawData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error || ![rawData isKindOfClass:[NSDictionary class]]) return @{
        @"conditions": @[],
        @"departments": @[],
        @"risk_level": @"clinic_soon",
        @"next_step": @"Local data is invalid. Please seek clinician support.",
        @"matched_rules": @[],
        @"needs_follow_up": @NO
    };

    BOOL ruleEngineEnabled = [UserDefaultsHelper boolForKey:kRuleEngineEnabledKey defaultValue:YES];
    NSString *sensitivity = [UserDefaultsHelper stringForKey:kRiskSensitivityKey defaultValue:@"normal"];
    NSDictionary *ruleResult = ruleEngineEnabled ? [TriageRuleEngine evaluateText:text dataStore:rawData sensitivity:sensitivity] : @{
        @"risk_level": @"home_care",
        @"next_step": @"Home care and monitor symptoms.",
        @"matched_rules": @[]
    };

    NSArray *inputKeywords = [[text lowercaseString] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableSet *foundConditions = [NSMutableSet set];
    NSMutableSet *foundDepartments = [NSMutableSet set];
    NSDictionary *symptomMap = [rawData[@"symptoms"] isKindOfClass:[NSDictionary class]] ? rawData[@"symptoms"] : @{};

    for (NSString *keyword in inputKeywords) {
        if (keyword.length == 0) continue;

        NSDictionary *entry = symptomMap[keyword];
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

    NSString *model = [UserDefaultsHelper stringForKey:kSelectedModelKey defaultValue:@"Simple"];
    NSString *language = [UserDefaultsHelper stringForKey:kSelectedLanguageKey defaultValue:@"English"];
    BOOL wantsFollowUp = [model isEqualToString:@"Advanced"];
    BOOL hasFollowUp = followUpAnswer.length > 0;
    NSString *riskLevel = [ruleResult[@"risk_level"] isKindOfClass:[NSString class]] ? ruleResult[@"risk_level"] : @"home_care";

    if (hasFollowUp) {
        NSString *answer = followUpAnswer.lowercaseString;
        if ([answer containsString:@"3"] || [answer containsString:@">3"] || [answer containsString:@"severe"] || [answer containsString:@"严重"]) {
            if (![riskLevel isEqualToString:@"emergency"]) {
                riskLevel = @"clinic_soon";
            }
        }
    }

    BOOL needsFollowUp = wantsFollowUp && !hasFollowUp && ![riskLevel isEqualToString:@"emergency"];
    NSString *followUpQuestion = [language isEqualToString:@"中文"] ? @"症状持续多久？(例如: <24h / 1-3d / >3d)" : @"How long have symptoms lasted? (e.g. <24h / 1-3d / >3d)";

    NSString *nextStep = [ruleResult[@"next_step"] isKindOfClass:[NSString class]] ? ruleResult[@"next_step"] : @"";
    if (nextStep.length == 0) {
        nextStep = [language isEqualToString:@"中文"] ? @"如症状持续或加重，请尽快就医。" : @"If symptoms persist or worsen, visit clinic soon.";
    }

    return @{
        @"conditions": [foundConditions allObjects],
        @"departments": [foundDepartments allObjects],
        @"risk_level": riskLevel,
        @"next_step": nextStep,
        @"matched_rules": [ruleResult[@"matched_rules"] isKindOfClass:[NSArray class]] ? ruleResult[@"matched_rules"] : @[],
        @"needs_follow_up": @(needsFollowUp),
        @"follow_up_question": followUpQuestion
    };
}

@end
