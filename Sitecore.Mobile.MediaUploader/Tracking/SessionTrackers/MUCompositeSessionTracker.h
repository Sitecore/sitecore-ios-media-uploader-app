#import <Sitecore.Mobile.MediaUploader/Tracking/MUSessionTracker.h>
#import <Foundation/Foundation.h>

@interface MUCompositeSessionTracker : NSObject<MUSessionTracker>

-(instancetype)initWithTrackers:( NSArray* )primitiveTrackers;

@end
