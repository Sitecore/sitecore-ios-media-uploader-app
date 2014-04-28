//
//  sc_ViewsHelper.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 8/4/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sc_ViewsHelper : NSObject

+(UIViewController*)reloadParentController:(UINavigationController*)navigationController
                                    levels:(NSUInteger)levels;

@end
