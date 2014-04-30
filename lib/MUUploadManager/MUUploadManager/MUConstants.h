//
//  Constants.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/19/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#ifndef Sitecore_Mobile_MediaUploader_MUConstants_h
#define Sitecore_Mobile_MediaUploader_MUConstants_h

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM (NSInteger, MUImageQuality)
{
    UPLODIMAGESIZE_SMALL  = 0,
    UPLODIMAGESIZE_MEDIUM = 1,
    UPLODIMAGESIZE_ACTUAL = 2
};

typedef NS_ENUM(NSInteger, MUUploadItemStatusType)
{
    READY_FOR_UPLOAD = 0,
    UPLOAD_IN_PROGRESS,
	UPLOAD_ERROR,
	UPLOAD_DONE,
    UPLOAD_CANCELED,
    DATA_IS_NOT_AVAILABLE
};

typedef NS_ENUM(NSInteger, MUFilteringOptions)
{
    SHOW_ALL_ITEMS = 0,
    SHOW_COMLETED_ITEMS,
	SHOW_NOT_COMLETED_ITEMS,
};

OBJC_EXTERN NSString* const VIDEO_TEMPLATE_PATH     ;
OBJC_EXTERN NSString* const IMAGE_TEMPLATE_PATH     ;
OBJC_EXTERN NSString* const IMAGE_JPEG_TEMPLATE_PATH;
OBJC_EXTERN NSString* const MEDIA_FOLDER_PATH       ;
OBJC_EXTERN NSString* const ITEM_TEMPLATE_PATH      ;


@interface MUConstants : NSObject

+(CGSize)mediumImageSize;
+(CGSize)smallImageSize;

@end


#endif
