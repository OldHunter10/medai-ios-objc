#import <Foundation/Foundation.h>

@interface TriageRuleEngine : NSObject

+ (NSDictionary *)evaluateText:(NSString *)text
                      dataStore:(NSDictionary *)dataStore
                    sensitivity:(NSString *)sensitivity;

@end
