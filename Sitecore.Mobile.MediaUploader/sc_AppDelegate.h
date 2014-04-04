//
//  sc_AppDelegate.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/2/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sc_AppDelegateProtocol.h"
@class sc_GlobalDataObject;

#define AppDelegate (sc_AppDelegate *)[[UIApplication sharedApplication] delegate]
@interface sc_AppDelegate : UIResponder <UIApplicationDelegate, sc_AppDelegateProtocol>

@property (nonatomic, retain) sc_GlobalDataObject* appDataObject;
@property (strong, nonatomic) UIWindow *window;

@end
