#import <MUAnalyticsTracker/MUSessionTracker.h>
#import <Foundation/Foundation.h>

@class GAI;
@protocol GAITracker;

@interface MUGoogleSessionTracker : NSObject<MUSessionTracker>

-(instancetype)initWithGoogleAnalytics:( GAI* )analytics
                               tracker:( id<GAITracker> )googleTracker;

@end
