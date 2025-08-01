//
//  DebugHelper.m
//  medai-ios-objc
//
//  Created by JC on 2025/8/1.
//

#import "DebugHelper.h"

@implementation DebugHelper
+ (void)logJSON:(NSDictionary *)json {
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }
}
@end
