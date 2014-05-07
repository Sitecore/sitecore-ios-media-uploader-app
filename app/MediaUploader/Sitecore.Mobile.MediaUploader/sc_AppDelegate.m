//
//  sc_AppDelegate.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/2/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_AppDelegate.h"
#import "sc_AppDelegateProtocol.h"
#import "sc_GlobalDataObject.h"
#import "sc_ConnectivityHelper.h"

#define TEST_ANALYTICS 1
#define ANALYTICS_ENABLED 1


@implementation sc_AppDelegate
{
    id<GAITracker> _sessionEventsTracker;
}


@synthesize window = _window;


// @adk
// TODO : extract analytics setup to a separate class
-(void)enableGoogleAnalytics
{
    GAI* analytics = [ GAI sharedInstance ];
    analytics.trackUncaughtExceptions = YES;

#if TEST_ANALYTICS
    {
        static const NSInteger HALF_MINUTE = 30;
        analytics.dispatchInterval = HALF_MINUTE;
    }
#else
    {
        static const NSInteger ONE_HOUR = 60 * 60;
        analytics.dispatchInterval = ONE_HOUR;
    }
#endif
    
    self->_sessionEventsTracker =  [ analytics trackerWithName: @"net.sitecore.medua-uploader.session-events"
                                                    trackingId: @"UA-50047147-1" ];
}

-(void)enableCrashlytics
{
    static NSString* const CRASHLYTICS_API_KEY = @"4c24cc2513a38654d20f77a8fcd8b67e09e0bbfa";
    [ Crashlytics startWithAPIKey: CRASHLYTICS_API_KEY ];
}

-(void)enableFlurryUsingLaunchOptions:(NSDictionary*)launchOptions
{
    static NSString* const FLURRY_API_KEY = @"K457XY59FHYQCT76JCX3";
    
    [ Flurry setSessionReportsOnCloseEnabled: YES ];
    [ Flurry setSessionReportsOnPauseEnabled: YES ];
    [ Flurry setCrashReportingEnabled       : YES ];
    [ Flurry setShowErrorInLogEnabled       : YES ];
    [ Flurry setSecureTransportEnabled      : YES ];
    
    NSString* userId = [ [ [ UIDevice currentDevice ] identifierForVendor ] UUIDString ];
    [ Flurry setUserID: userId ];
    

    
#if DEBUG
    {
        [ Flurry setDebugLogEnabled: YES ];
    }
#endif
    
    [ Flurry startSession: FLURRY_API_KEY
              withOptions: launchOptions ];
}

-(void)runCacheFilesMigration
{
    BOOL isMigrationSuccessful = NO;
    
    NSFileManager* fm = [ NSFileManager defaultManager ];
    NSString* documentsDirectory = [ sc_GlobalDataObject applicationDocumentsDir ];
    
    NSError* migrationError = nil;
    MUApplicationMigrator* migrator = [ [ MUApplicationMigrator alloc ] initWithFileManager: fm
                                                                         rootCacheDirectory: documentsDirectory ];
    isMigrationSuccessful = [ migrator migrateUploaderAppWithError: &migrationError ];


    if ( !isMigrationSuccessful )
    {
        UIAlertView* alert = [ [ UIAlertView alloc ] initWithTitle: NSLocalizedString( @"ERROR_ALERT_TITLE", nil )
                                                           message: @"ERROR_MIGRATION_FAILED"
                                                          delegate: nil
                                                 cancelButtonTitle: NSLocalizedString( @"OK", nil )
                                                 otherButtonTitles: nil ];
        [ alert show ];
        
        [ [ MUEventsTrackerFactory sessionTrackerForMediaUploader ] appMigrationFailedWithError: migrationError ];
    }
}

-(BOOL)application:(UIApplication*)application
didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
#if ANALYTICS_ENABLED
    {
        [ self enableGoogleAnalytics ];
        [ self enableCrashlytics ];
        [ self enableFlurryUsingLaunchOptions: launchOptions ];
    }
#endif

    [ self runCacheFilesMigration ];
    self->_appDataObject = [ [ sc_GlobalDataObject alloc ] init ];
    
    [self getIOS];
    [self initializeStoryBoardBasedOnScreenSize];
    return YES;
}

-(void)getIOS
{
    _appDataObject.IOS = [[[UIDevice currentDevice] systemVersion] intValue];
}

-(void)initializeStoryBoardBasedOnScreenSize
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName: @"MainStoryboard_iPhone"
                                                         bundle: nil];
    _appDataObject.isIpad = NO;
    
    UIViewController* initialViewController = [storyboard instantiateInitialViewController];
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    self.window.rootViewController  = initialViewController;
    
    [self.window makeKeyAndVisible];

}

@end
