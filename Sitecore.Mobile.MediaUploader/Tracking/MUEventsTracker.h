
#import <Sitecore.Mobile.MediaUploader/Tracking/MUTrackable.h>
#import <Foundation/Foundation.h>


/**
 A tracker that holds references to domain specific trackers.
 It may report to one or more tracking services.
 */
@protocol MUSessionTracker;


/**
 A root tracker for all events in the application
 */
@protocol MUEventsTracker <NSObject>

/**
 @return An interface for tracking login and logout events.
 */
-(id<MUSessionTracker>)sessionTracker;


@end
