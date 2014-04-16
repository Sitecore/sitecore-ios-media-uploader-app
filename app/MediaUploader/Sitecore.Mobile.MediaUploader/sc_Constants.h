//
//  Constants.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/19/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#ifndef Sitecore_Mobile_MediaUploader_sc_Constants_h
#define Sitecore_Mobile_MediaUploader_sc_Constants_h

#import <Foundation/Foundation.h>

enum
{
    UPLODIMAGESIZE_SMALL  = 0,
    UPLODIMAGESIZE_MEDIUM = 1,
    UPLODIMAGESIZE_ACTUAL = 2
};

OBJC_EXTERN NSString* const VIDEO_TEMPLATE_PATH     ;
OBJC_EXTERN NSString* const IMAGE_TEMPLATE_PATH     ;
OBJC_EXTERN NSString* const IMAGE_JPEG_TEMPLATE_PATH;
OBJC_EXTERN NSString* const MEDIA_FOLDER_PATH       ;
OBJC_EXTERN NSString* const ITEM_TEMPLATE_PATH      ;


@interface sc_Constants : NSObject

+(CGSize)mediumImageSize;
+(CGSize)smallImageSize;

@end


#endif
