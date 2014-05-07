#import "MUFlurrySessionTracker.h"

#import "MUTrackable.h"

@implementation MUFlurrySessionTracker

-(NSString*)messageForNewSession:(id<MUTrackable> )site
{
    NSString* sessionInfo =
    [ NSString stringWithFormat:
     @"   New session info : \n"
     @"   %@ \n", site ];

    return sessionInfo;
}

-(NSDictionary*)dictionaryFromSession:(id<MUTrackable>)site
{
    // TODO : use specific properties of SCSite instead
    NSDictionary* result =
    @{
        @"Session Info" : [ self messageForNewSession: site ]
    };
    
    return result;
}

-(void)appMigrationFailedWithError:( NSError* )error
{
    [ Flurry logError: @"Migration Failed"
              message: @"Migration Failed"
                error: error ];
}

-(void)didLoginWithSite:(id<MUTrackable>)site
{
    NSDictionary* sessionParams = [ self dictionaryFromSession: site ];
    
    [ Flurry logEvent: @"LOGIN"
       withParameters: sessionParams ];
}


-(void)didLoginFailedForSite:(id<MUTrackable>)site
                   withError:(NSError*)error
{    
    NSString* sessionInfo = [ self messageForNewSession: site ];
    
    [ Flurry logError: @"Login failed"
              message: sessionInfo
                error: error ];
}

-(void)didLogoutFromSite:(id<MUTrackable>)site
{
    NSDictionary* sessionParams = [ self dictionaryFromSession: site ];
    
    [ Flurry logEvent: @"LOGOUT"
       withParameters: sessionParams ];
}

@end
