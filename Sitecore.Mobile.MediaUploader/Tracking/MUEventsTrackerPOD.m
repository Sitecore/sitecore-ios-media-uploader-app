
#import "MUEventsTrackerPOD.h"

@implementation MUEventsTrackerPOD

-(instancetype)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithSessionTracker:( id<MUSessionTracker> )sessionTracker
{
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }
    
    self->_sessionTracker = sessionTracker;
    
    return self;
}

@end
