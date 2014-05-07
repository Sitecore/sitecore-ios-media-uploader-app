#import "MUCrashlyticsSessionTracker.h"


@implementation MUCrashlyticsSessionTracker

-(void)appMigrationFailedWithError:( NSError* )error
{
    CLS_LOG( @"[Migration] Error: %@ \n", error );
}


-(void)didLoginWithSite:(id<MUTrackable> )site
{
    CLS_LOG( @"[LOGIN] Success! New session info : \n"
             @"%@ \n", site );
}


-(void)didLoginFailedForSite:(id<MUTrackable> )site
                   withError:(NSError*)error
{
    CLS_LOG( @"[LOGIN] Error : %@ "
             @"   New session info : \n"
             @"   %@ \n", error, site );

}

-(void)didLogoutFromSite:(id<MUTrackable> )site
{
    CLS_LOG( @"[LOGOUT] Success! Session info : \n"
             @"   %@ \n", site );
}

@end



