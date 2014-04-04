//
//  sc_Validator.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by Steve Jennings on 8/1/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sc_Validator : NSObject

+ (NSString *) proposeValidItemName: (NSString *) name withDefault: (NSString *) defaultValue;

@end
