#import "MUEventsTrackerFactory.h"

#import "MUEventsTracker.h"
#import "MUEventsTrackerPOD.h"
#import "MUCrashlyticsSessionTracker.h"

@implementation MUEventsTrackerFactory

+(id<MUEventsTracker>)trackerForMediaUploader
{
    static id<MUEventsTracker> result = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^void()
    {
        MUCrashlyticsSessionTracker* crashlyticSessionLogger = [ MUCrashlyticsSessionTracker new ];
        
        result = [ [ MUEventsTrackerPOD alloc ] initWithSessionTracker: crashlyticSessionLogger ];

    });

    return result;
}

+(id<MUSessionTracker>)sessionTrackerForMediaUploader
{
    return [ [ self trackerForMediaUploader ] sessionTracker ];
}

@end
