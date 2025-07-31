//
//  HistoryManager.m
//  medai-ios-objc
//
//  Created by JC on 2025/7/31.
//

#import "HistoryManager.h"

@implementation HistoryManager

#define HISTORY_KEY @"user_query_history"

+ (void)saveQuery:(NSString *)query {
    if (query.length == 0) return;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *oldHistory = [defaults objectForKey:HISTORY_KEY] ?: @[];
    NSMutableArray *mutable = [oldHistory mutableCopy];
    
    if ([mutable containsObject:query]) {
        [mutable removeObject:query]; // move to top
    }
    [mutable insertObject:query atIndex:0];
    
    // limit to 20 entries
    if (mutable.count > 20) {
        [mutable removeLastObject];
    }
    
    [defaults setObject:mutable forKey:HISTORY_KEY];
    [defaults synchronize];
}

+ (NSArray<NSString *> *)loadHistory {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *history = [defaults objectForKey:HISTORY_KEY];
    if ([history isKindOfClass:[NSArray class]]) {
        return history;
    }
    return @[];
}

+ (void)clearHistory {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:HISTORY_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
