#import <Foundation/Foundation.h>

@protocol MUEventsTracker;
@protocol MUSessionTracker;


@interface MUEventsTrackerFactory : NSObject

+(id<MUEventsTracker>)trackerForMediaUploader;
+(id<MUSessionTracker>)sessionTrackerForMediaUploader;

@end
