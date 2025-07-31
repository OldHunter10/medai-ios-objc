//
//  HistoryManager.h
//  medai-ios-objc
//
//  Created by JC on 2025/7/31.
//

#import <Foundation/Foundation.h>

@interface HistoryManager : NSObject

+ (void)saveQuery:(NSString *)query;
+ (NSArray<NSString *> *)loadHistory;
+ (void)clearHistory;

@end
