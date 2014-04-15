#import <Sitecore.Mobile.MediaUploader/Tracking/MUEventsTracker.h>
#import <Foundation/Foundation.h>

@protocol MUSessionTracker;

/**
 A tracker that holds explicit strong references to domain specific trackers.
 */
@interface MUEventsTrackerPOD : NSObject<MUEventsTracker>

/**
 Unsupported initializer.
 
 @return nil for disabled asserts. Thows an exception otherwise.
 */
-(instancetype)init;


/**
 A designated initializer.
 
 @param sessionTracker A tracker for login and logout services. 
 Note : It may report to one or more services.
 
 @return An initialized instance of "self"
 */
-(instancetype)initWithSessionTracker:( id<MUSessionTracker> )sessionTracker;


/**
 An interface for tracking login and logout events.
 */
@property ( nonatomic, readonly ) id<MUSessionTracker> sessionTracker;


@end
