//
//  sc_DeviceHelper.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by Steve Jennings on 8/16/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_DeviceHelper.h"
#import <sys/utsname.h>

@implementation sc_DeviceHelper

+(NSString*)getDeviceType
{
    struct utsname systemInfo;
    uname( &systemInfo );
    
    NSString* iOSDeviceModelsPath = [ [NSBundle mainBundle] pathForResource: @"iOSDeviceModelMapping"
                                                                     ofType: @"plist" ];
    NSDictionary* iOSDevices = [ NSDictionary dictionaryWithContentsOfFile: iOSDeviceModelsPath ];
    
    NSString* deviceModel = [ NSString stringWithCString: systemInfo.machine
                                                encoding: NSUTF8StringEncoding ];
    
    return [ iOSDevices valueForKey: deviceModel ];
}

@end
