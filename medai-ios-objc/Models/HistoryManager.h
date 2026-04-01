//
//  HistoryManager.h
//  medai-ios-objc
//
//  Created by JC on 2025/7/31.
//

#import <Foundation/Foundation.h>

@interface HistoryManager : NSObject

+ (void)saveQuery:(NSString *)query;
+ (void)saveRecordWithText:(NSString *)text resultSummary:(NSString *)resultSummary riskLevel:(NSString *)riskLevel;
+ (NSArray<NSDictionary *> *)loadHistory;
+ (void)clearHistory;
+ (void)deleteRecord:(NSString *)recordText;
@end
