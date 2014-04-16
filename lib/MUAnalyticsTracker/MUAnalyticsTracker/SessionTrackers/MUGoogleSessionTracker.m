#import "MUGoogleSessionTracker.h"

#import "MUTrackable.h"

@implementation MUGoogleSessionTracker
{
    id<GAITracker> _googleTracker;
}


-(instancetype)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithGoogleTracker:( id<GAITracker> )googleTracker
{
    self = [ super init ];
    if ( nil == self )
    {
        return  nil;
    }
    
    self->_googleTracker = googleTracker;
    
    return self;
}

-(void)didLoginWithSite:(id<MUTrackable> )site
{
    GAIDictionaryBuilder* event = [ GAIDictionaryBuilder createEventWithCategory: @"Authentication"
                                                                          action: @"Login Successfull"
                                                                           label: @"Session Settings"
                                                                           value: [ site description ] ];

    [ self->_googleTracker send: [ event build ] ];
}


-(void)didLoginFailedForSite:(id<MUTrackable> )site
                   withError:(NSError*)error
{
    GAIDictionaryBuilder* event = [ GAIDictionaryBuilder createEventWithCategory: @"Authentication"
                                                                          action: @"Login Failed"
                                                                           label: @"Session Settings"
                                                                           value: [ site description ] ];
    [ event set: [ error description ]
         forKey: @"error" ];
    
    
    [ self->_googleTracker send: [ event build ] ];
}


-(void)didLogoutFromSite:(id<MUTrackable> )site
{
    GAIDictionaryBuilder* event = [ GAIDictionaryBuilder createEventWithCategory: @"Authentication"
                                                                          action: @"Logout"
                                                                           label: @"Session Settings"
                                                                           value: [ site description ] ];
    
    [ self->_googleTracker send: [ event build ] ];
    
}

@end
