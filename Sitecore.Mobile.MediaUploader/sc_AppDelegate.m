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
    // set default storyboard to iphone 5
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    _appDataObject.isIpad = false;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        // The iOS device = iPhone or iPod Touch
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 480)
        {   // iPhone 3GS, 4, and 4S and iPod Touch 3rd and 4th generation: 3.5 inch screen (diagonally measured)
            storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone3.5" bundle:nil];
        }
    }
    else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {   // The iOS device = iPad
        _appDataObject.isIpad = true;
        // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone4
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    } 
    
    // Instantiate the initial view controller object from the storyboard
    UIViewController *initialViewController = [storyboard instantiateInitialViewController];
    
    // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Set the initial view controller to be the root view controller of the window object
    self.window.rootViewController  = initialViewController;
    
    // Set the window object to be the key window and show it
    [self.window makeKeyAndVisible];

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [(UINavigationController *)self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
    [(UINavigationController *)self.window.rootViewController popToRootViewControllerAnimated:NO];    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
