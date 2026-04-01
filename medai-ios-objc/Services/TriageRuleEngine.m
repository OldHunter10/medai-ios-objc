#import "TriageRuleEngine.h"

@implementation TriageRuleEngine

+ (NSDictionary *)evaluateText:(NSString *)text
                      dataStore:(NSDictionary *)dataStore
                    sensitivity:(NSString *)sensitivity {
    NSString *lowerText = [text.lowercaseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *rules = [dataStore[@"red_flags"] isKindOfClass:[NSArray class]] ? dataStore[@"red_flags"] : @[];
    NSMutableArray *matchedRules = [NSMutableArray array];
    NSString *riskLevel = @"home_care";
    NSString *nextStep = @"Home care and monitor symptoms.";

    BOOL isHighSensitivity = [[sensitivity lowercaseString] isEqualToString:@"high"];

    for (NSDictionary *rule in rules) {
        if (![rule isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        NSArray *keywords = [rule[@"keywords"] isKindOfClass:[NSArray class]] ? rule[@"keywords"] : @[];
        NSString *severity = [rule[@"severity"] isKindOfClass:[NSString class]] ? rule[@"severity"] : @"medium";
        NSString *ruleName = [rule[@"name"] isKindOfClass:[NSString class]] ? rule[@"name"] : @"Rule";
        NSString *advice = [rule[@"advice"] isKindOfClass:[NSString class]] ? rule[@"advice"] : @"Seek medical care.";

        BOOL matched = NO;
        for (NSString *keyword in keywords) {
            if ([keyword isKindOfClass:[NSString class]] && keyword.length > 0 && [lowerText containsString:keyword.lowercaseString]) {
                matched = YES;
                break;
            }
        }
        if (!matched) {
            continue;
        }

        [matchedRules addObject:ruleName];
        if ([severity isEqualToString:@"high"]) {
            riskLevel = @"emergency";
            nextStep = advice;
            break;
        }
        if ([riskLevel isEqualToString:@"home_care"]) {
            riskLevel = @"clinic_soon";
            nextStep = advice;
        }
    }

    if (isHighSensitivity && [riskLevel isEqualToString:@"home_care"] && lowerText.length > 0) {
        riskLevel = @"clinic_soon";
        nextStep = @"Symptoms need closer observation. If persistent, visit clinic soon.";
    }

    return @{
        @"risk_level": riskLevel,
        @"next_step": nextStep,
        @"matched_rules": matchedRules
    };
}

@end
