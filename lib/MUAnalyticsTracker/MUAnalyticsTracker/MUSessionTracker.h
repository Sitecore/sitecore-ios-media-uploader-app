#import <Foundation/Foundation.h>

@protocol MUTrackable;

/**
 Tracks successful and failed login attempts.
 */
@protocol MUSessionTracker <NSObject>


/**
 Tracks logout event.
 
 @param site An object that holds the infomation about current session.
 */
-(void)didLoginWithSite:(id<MUTrackable> )site;



/**
 Tracks unsuccessful login event.
 
 @param site An object that holds the infomation about new session.
 @param error An authentication error.
 */
-(void)didLoginFailedForSite:(id<MUTrackable> )site
                   withError:(NSError*)error;


/**
 Tracks successful login event.
 
 @param site An object that holds the infomation about new session.
 */
-(void)didLogoutFromSite:(id<MUTrackable> )site;

@end
