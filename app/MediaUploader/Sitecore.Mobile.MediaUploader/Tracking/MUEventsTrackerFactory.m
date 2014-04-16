#import "MUEventsTrackerFactory.h"


@implementation MUEventsTrackerFactory

+(id<MUSessionTracker>)createNewSessionTrackerForMediaUploader
{
    MUCrashlyticsSessionTracker* crashlyticSessionLogger = [ MUCrashlyticsSessionTracker new ];
    MUFlurrySessionTracker* flurryLogger = [ MUFlurrySessionTracker new ];
    
    
    GAI* googleAnalytics = [ GAI sharedInstance ];
    id<GAITracker> googleTracker = [ googleAnalytics defaultTracker ];
    MUGoogleSessionTracker* googleLogger = [ [ MUGoogleSessionTracker alloc ] initWithGoogleAnalytics: googleAnalytics
                                                                                              tracker: googleTracker ];
    
    NSArray* sessionTrackers =
    @[
      crashlyticSessionLogger,
      flurryLogger,
      googleLogger
      ];
    
    MUCompositeSessionTracker* compositeTracker =
    [ [ MUCompositeSessionTracker alloc ] initWithTrackers:sessionTrackers ];
    
    return compositeTracker;
}

+(id<MUEventsTracker>)trackerForMediaUploader
{
    static id<MUEventsTracker> result = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^void()
    {
        id<MUSessionTracker> loginTracker = [ self createNewSessionTrackerForMediaUploader ];
        result = [ [ MUEventsTrackerPOD alloc ] initWithSessionTracker: loginTracker ];
    });

    return result;
}

+(id<MUSessionTracker>)sessionTrackerForMediaUploader
{
    return [ [ self trackerForMediaUploader ] sessionTracker ];
}

@end
