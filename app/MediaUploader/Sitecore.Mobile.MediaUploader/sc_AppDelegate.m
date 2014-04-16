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

@implementation sc_AppDelegate
@synthesize window = _window;

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

-(BOOL)application:(UIApplication*)application
didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    _appDataObject = [[sc_GlobalDataObject alloc] init];
    
    [ self enableCrashlytics ];
    [ self enableFlurryUsingLaunchOptions: launchOptions ];

    
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
    _appDataObject.isIpad = false;
    
    UIViewController* initialViewController = [storyboard instantiateInitialViewController];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController  = initialViewController;
    
    [self.window makeKeyAndVisible];

}

@end
