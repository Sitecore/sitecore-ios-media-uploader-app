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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _appDataObject = [[sc_GlobalDataObject alloc] init];
    
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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    _appDataObject.isIpad = false;
    
    UIViewController *initialViewController = [storyboard instantiateInitialViewController];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController  = initialViewController;
    
    [self.window makeKeyAndVisible];

}

@end
