#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EncounterSessionState) {
    EncounterSessionStateIdle = 0,
    EncounterSessionStateAwaitingFollowUp = 1,
    EncounterSessionStateCompleted = 2
};

@interface EncounterSession : NSObject

@property (nonatomic, copy) NSString *initialSymptoms;
@property (nonatomic, copy) NSString *followUpAnswer;
@property (nonatomic, assign) EncounterSessionState state;

- (instancetype)initWithSymptoms:(NSString *)symptoms;

@end
