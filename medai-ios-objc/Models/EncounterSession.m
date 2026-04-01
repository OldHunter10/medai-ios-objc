#import "EncounterSession.h"

@implementation EncounterSession

- (instancetype)initWithSymptoms:(NSString *)symptoms {
    self = [super init];
    if (self) {
        _initialSymptoms = symptoms ?: @"";
        _followUpAnswer = @"";
        _state = EncounterSessionStateIdle;
    }
    return self;
}

@end
