//
//  medai_ios_objcTests.m
//  medai-ios-objcTests
//
//  Created by JC on 2025/7/26.
//

#import <XCTest/XCTest.h>
#import "HistoryManager.h"
#import "TriageRuleEngine.h"
#import "Constants.h"

@interface medai_ios_objcTests : XCTestCase

@end

@implementation medai_ios_objcTests

- (void)setUp {
    [super setUp];
    [HistoryManager clearHistory];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRiskSensitivityKey];
}

- (void)tearDown {
    [HistoryManager clearHistory];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRiskSensitivityKey];
    [super tearDown];
}

- (void)testHistoryManagerStoresDictionaryRecord {
    [HistoryManager saveRecordWithText:@"fever headache" resultSummary:@"Viral Infection" riskLevel:@"Clinic Soon"];
    NSArray<NSDictionary *> *history = [HistoryManager loadHistory];
    XCTAssertEqual(history.count, 1);
    NSDictionary *entry = history.firstObject;
    XCTAssertEqualObjects(entry[@"text"], @"fever headache");
    XCTAssertEqualObjects(entry[@"summary"], @"Viral Infection");
    XCTAssertEqualObjects(entry[@"riskLevel"], @"Clinic Soon");
}

- (void)testTriageRuleEngineReturnsEmergency {
    NSDictionary *store = @{
        @"red_flags": @[
            @{
                @"name": @"ChestPainEmergency",
                @"severity": @"high",
                @"keywords": @[@"chest pain"],
                @"advice": @"Go to emergency now."
            }
        ]
    };
    NSDictionary *result = [TriageRuleEngine evaluateText:@"Severe chest pain today" dataStore:store sensitivity:@"normal"];
    XCTAssertEqualObjects(result[@"risk_level"], @"emergency");
    XCTAssertEqualObjects(result[@"next_step"], @"Go to emergency now.");
}

@end
