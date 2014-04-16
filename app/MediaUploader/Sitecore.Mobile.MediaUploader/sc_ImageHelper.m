//
//  sc_ImageHelper.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 8/4/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_ImageHelper.h"
#import "sc_Constants.h"
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVAsset.h>
#import "sc_ImageScaling.h"

@implementation sc_ImageHelper

+(CGFloat)getCompressionFactor:(int) uploadImageSize
{
    if (uploadImageSize == UPLODIMAGESIZE_ACTUAL)
    {
        return 1;
    }
    
    if (uploadImageSize == UPLODIMAGESIZE_MEDIUM)
    {
        return 0.8f;
    }
    
    return 0.6f;
}

+(UIImage*)resizeImageToSize:(UIImage*)image uploadImageSize:(int)uploadImageSize
{
    if (uploadImageSize == UPLODIMAGESIZE_ACTUAL)
    {
        return image;
    }
    
    CGSize size;
    
    size = [ sc_Constants smallImageSize ];
    
    if (uploadImageSize == UPLODIMAGESIZE_MEDIUM)
    {
        size = [ sc_Constants mediumImageSize ];
    }
    
    UIImage* result =  [ sc_ImageScaling scaleImage: image
                                             toSize: size ];
    
    return result;
}

+(void)saveUploadImageSize:(int) uplaodImageSize
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:uplaodImageSize forKey:@"UploadImageSize"];
    [defaults synchronize];
}

+(int)loadUploadImageSize
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey: @"UploadImageSize"];
}

+(UIImage*)getVideoThumbnail:(NSURL*) videoUrl
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generate.appliesPreferredTrackTransform = YES;
    NSError* err = NULL;
    CMTime time = CMTimeMake(0,60);
    CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
    UIImage*  thumbnail = [[UIImage alloc] initWithCGImage:imgRef];
    return thumbnail;
}

+(NSString*)getUUID
{
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    NSString*  uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    CFRelease(newUniqueId);
    
    return uuidString;
}

+(UIImage*)normalize:(UIImage*)image forOrientation:(UIImageOrientation)orientation
{
    if (orientation == UIImageOrientationUp || orientation == UIImageOrientationUpMirrored)
    {
        return image;
    }
    
    //Translate and rotate
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (orientation)
    {
        case UIImageOrientationDown: //1
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft: // 2
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:// 3
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.width);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        case UIImageOrientationUp: // 0
        case UIImageOrientationUpMirrored:
            break;
    }
    
    CGContextRef ctx;
    switch (orientation)
    {
        case UIImageOrientationRight:
        case UIImageOrientationLeft:
        case UIImageOrientationRightMirrored:
        case UIImageOrientationLeftMirrored:
            
            ctx = CGBitmapContextCreate(NULL, image.size.height, image.size.width,
                                        CGImageGetBitsPerComponent(image.CGImage), 0,
                                        CGImageGetColorSpace(image.CGImage),
                                        CGImageGetBitmapInfo(image.CGImage));
            break;
            
        default:
            ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                        CGImageGetBitsPerComponent(image.CGImage), 0,
                                        CGImageGetColorSpace(image.CGImage),
                                        CGImageGetBitmapInfo(image.CGImage));
            break;
    }
    
    CGContextConcatCTM(ctx, transform);
    CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
    
    // Create new image
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage* img = [UIImage imageWithCGImage: cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

@end
