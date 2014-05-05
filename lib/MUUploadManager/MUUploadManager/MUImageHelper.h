//
//  MUImageHelper.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 8/4/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <MUUploadManager/MUConstants.h>

//TODO @igk move image processing to the separate library
@interface MUImageHelper : NSObject

+(CGFloat)getCompressionFactor:(MUImageQuality)uploadImageSize;
+(UIImage*)resizeImageToSize:(UIImage*)image uploadImageSize:(MUImageQuality)uploadImageSize;
+(void)saveUploadImageSize:(MUImageQuality)uplaodImageSize;
+(MUImageQuality)loadUploadImageSize;
+(UIImage*)getVideoThumbnail:(NSURL*)videoUrl;
+(UIImage*)normalize:(UIImage*)image forOrientation:(UIImageOrientation)orientation;

@end
