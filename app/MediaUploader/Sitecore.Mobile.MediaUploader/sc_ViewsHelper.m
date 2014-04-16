//
//  sc_ViewsHelper.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 8/4/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_ViewsHelper.h"
#import "sc_ReloadableViewProtocol.h"

@implementation sc_ViewsHelper

+(UIViewController *)reloadParentController:(UINavigationController*) navigationController levels:(int) levels
{
    NSArray* viewControllers = [navigationController viewControllers];
    UIViewController * viewController = [viewControllers objectAtIndex:viewControllers.count - levels];
    if ([viewController conformsToProtocol:@protocol(sc_ReloadableViewProtocol)])
    {
        UIViewController <sc_ReloadableViewProtocol> *reloadableController = (UIViewController <sc_ReloadableViewProtocol> *) viewController;
        [reloadableController reload];
        return reloadableController;
    }
    
    return nil;
}

@end
