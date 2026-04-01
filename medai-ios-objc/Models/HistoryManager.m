//
//  HistoryManager.m
//  medai-ios-objc
//
//  Created by JC on 2025/7/31.
//

#import "HistoryManager.h"
#import "Constants.h"

@implementation HistoryManager

+ (void)saveQuery:(NSString *)query {
    [self saveRecordWithText:query resultSummary:@"" riskLevel:@""];
}

+ (void)saveRecordWithText:(NSString *)text resultSummary:(NSString *)resultSummary riskLevel:(NSString *)riskLevel {
    if (text.length == 0) return;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray<NSDictionary *> *oldHistory = [self loadHistory];
    NSMutableArray<NSDictionary *> *mutable = [oldHistory mutableCopy];

    NSIndexSet *duplicateIndexes = [mutable indexesOfObjectsPassingTest:^BOOL(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *oldText = obj[@"text"];
        return [oldText isKindOfClass:[NSString class]] && [oldText isEqualToString:text];
    }];
    if (duplicateIndexes.count > 0) {
        [mutable removeObjectsAtIndexes:duplicateIndexes];
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateString = [formatter stringFromDate:[NSDate date]];

    NSDictionary *record = @{
        @"text": text,
        @"date": dateString ?: @"",
        @"riskLevel": riskLevel ?: @"",
        @"summary": resultSummary ?: @""
    };
    [mutable insertObject:record atIndex:0];

    if (mutable.count > MAX_HISTORY_COUNT) {
        [mutable removeObjectsInRange:NSMakeRange(MAX_HISTORY_COUNT, mutable.count - MAX_HISTORY_COUNT)];
    }

    [defaults setObject:mutable forKey:HISTORY_KEY];
    [defaults synchronize];
}

+ (NSArray<NSDictionary *> *)loadHistory {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *history = [defaults objectForKey:HISTORY_KEY];
    if (![history isKindOfClass:[NSArray class]]) {
        return @[];
    }

    NSMutableArray<NSDictionary *> *normalized = [NSMutableArray array];
    for (id item in history) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            NSString *text = item[@"text"];
            if (![text isKindOfClass:[NSString class]] || text.length == 0) continue;
            NSString *date = [item[@"date"] isKindOfClass:[NSString class]] ? item[@"date"] : @"";
            NSString *riskLevel = [item[@"riskLevel"] isKindOfClass:[NSString class]] ? item[@"riskLevel"] : @"";
            NSString *summary = [item[@"summary"] isKindOfClass:[NSString class]] ? item[@"summary"] : @"";
            [normalized addObject:@{
                @"text": text,
                @"date": date,
                @"riskLevel": riskLevel,
                @"summary": summary
            }];
        } else if ([item isKindOfClass:[NSString class]]) {
            NSString *legacyText = (NSString *)item;
            if (legacyText.length > 0) {
                [normalized addObject:@{
                    @"text": legacyText,
                    @"date": @"",
                    @"riskLevel": @"",
                    @"summary": @""
                }];
            }
        }
    }

    return normalized;
}

+ (void)clearHistory {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:HISTORY_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)deleteRecord:(NSString *)recordText {
    if (recordText.length == 0) return;
    NSMutableArray *history = [[[self class] loadHistory] mutableCopy];
    NSUInteger index = [history indexOfObjectPassingTest:^BOOL(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *text = obj[@"text"];
        return [text isKindOfClass:[NSString class]] && [text isEqualToString:recordText];
    }];
    if (index != NSNotFound) {
        [history removeObjectAtIndex:index];
    }
    [[NSUserDefaults standardUserDefaults] setObject:history forKey:HISTORY_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
