#import "MUGoogleSessionTracker.h"

#import "MUTrackable.h"

static NSString* const MU_AUTHENTICATION_CATEGORY = @"Authentication";

static NSString* const MU_LOGIN_ACTION  = @"Login" ;
static NSString* const MU_LOGOUT_ACTION = @"Logout";

static NSString* const MU_SESSION_SETTINGS_KEY = @"Session Settings";


@implementation MUGoogleSessionTracker
{
    id<GAITracker> _googleTracker;
    GAI*           _analytics    ;
}


-(instancetype)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithGoogleAnalytics:( GAI* )analytics
                               tracker:( id<GAITracker> )googleTracker
{
    self = [ super init ];
    if ( nil == self )
    {
        return  nil;
    }
    
    self->_googleTracker = googleTracker;
    self->_analytics     = analytics    ;
    
    return self;
}

-(void)appMigrationFailedWithError:( NSError* )error
{
    GAIDictionaryBuilder* event = [ GAIDictionaryBuilder createEventWithCategory: @"Cache Migration"
                                                                          action: @"Cache Migration"
                                                                           label: @"Failed"
                                                                           value: @(0) ];
    
    [ event set: [ error description ]
         forKey: @"Login Error" ];
    
    [ self->_googleTracker send: [ event build ] ];
    [ self->_analytics dispatch ];
}

-(void)didLoginWithSite:(id<MUTrackable> )site
{
    GAIDictionaryBuilder* event = [ GAIDictionaryBuilder createEventWithCategory: MU_AUTHENTICATION_CATEGORY
                                                                          action: MU_LOGIN_ACTION
                                                                           label: @"Login Successfull"
                                                                           value: @(+1) ];
    
    [ event set: [ site description ]
         forKey: MU_SESSION_SETTINGS_KEY ];

    [ self->_googleTracker send: [ event build ] ];
    [ self->_analytics dispatch ];
}


-(void)didLoginFailedForSite:(id<MUTrackable> )site
                   withError:(NSError*)error
{
    GAIDictionaryBuilder* event = [ GAIDictionaryBuilder createEventWithCategory: MU_AUTHENTICATION_CATEGORY
                                                                          action: MU_LOGIN_ACTION
                                                                           label: @"Login Failed"
                                                                           value: @0 ];

    [ event set: [ site description ]
         forKey: MU_SESSION_SETTINGS_KEY ];
    
    [ event set: [ error description ]
         forKey: @"Login Error" ];
    
    
    [ self->_googleTracker send: [ event build ] ];
    [ self->_analytics dispatch ];
}


-(void)didLogoutFromSite:(id<MUTrackable> )site
{
    GAIDictionaryBuilder* event = [ GAIDictionaryBuilder createEventWithCategory: MU_AUTHENTICATION_CATEGORY
                                                                          action: MU_LOGOUT_ACTION
                                                                           label: @"Logout Successful"
                                                                           value: @(-1) ];
    
    [ event set: [ site description ]
         forKey: MU_SESSION_SETTINGS_KEY ];
    
    [ self->_googleTracker send: [ event build ] ];
    [ self->_analytics dispatch ];
}

@end
