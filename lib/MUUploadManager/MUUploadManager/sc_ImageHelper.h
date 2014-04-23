//
//  sc_ImageHelper.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 8/4/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface sc_ImageHelper : NSObject

+(CGFloat)getCompressionFactor:(int)uploadImageSize;
+(UIImage*)resizeImageToSize:(UIImage*)image uploadImageSize:(int)uploadImageSize;
+(void)saveUploadImageSize:(int)uplaodImageSize;
+(int)loadUploadImageSize;
+(UIImage*)getVideoThumbnail:(NSURL*)videoUrl;
+(NSString*)getUUID;
+(UIImage*)normalize:(UIImage*)image forOrientation:(UIImageOrientation)orientation;

@end
