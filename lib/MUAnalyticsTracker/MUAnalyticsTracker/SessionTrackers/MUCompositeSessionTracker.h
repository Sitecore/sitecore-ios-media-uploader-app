#import <MUAnalyticsTracker/MUSessionTracker.h>
#import <Foundation/Foundation.h>



/**
 A proxy session tracker that notifies other trackers that were passed to it in the constructor.
 Note : the order of calls is not guaranteed.
 */
@interface MUCompositeSessionTracker : NSObject<MUSessionTracker>


/**
 Unsupported initializer.
 
 @return nil for disabled asserts. Thows an exception otherwise.
 */
-(instancetype)init;



/**
 A designated initializer.
 
 @param primitiveTrackers An array of MUSessionTracker objects. The MUCompositeSessionTracker instance will forward method calls to all of them.
 
 
 
 */
-(instancetype)initWithTrackers:( NSArray* )primitiveTrackers;



@end
