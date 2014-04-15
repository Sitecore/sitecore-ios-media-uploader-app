//
//  sc_ConnectivityHelper.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 8/4/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_ConnectivityHelper.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"

@implementation sc_ConnectivityHelper

+ (BOOL)connectedToInternet
{
    Reachability *curReach = [Reachability reachabilityForInternetConnection];

    return ( curReach.currentReachabilityStatus != NotReachable );
}

@end
