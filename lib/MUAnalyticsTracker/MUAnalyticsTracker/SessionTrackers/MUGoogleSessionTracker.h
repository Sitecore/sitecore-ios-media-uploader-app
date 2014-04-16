#import <MUAnalyticsTracker/MUSessionTracker.h>
#import <Foundation/Foundation.h>

@protocol GAITracker;

@interface MUGoogleSessionTracker : NSObject<MUSessionTracker>

-(instancetype)initWithGoogleTracker:( id<GAITracker> )googleTracker;

@end
