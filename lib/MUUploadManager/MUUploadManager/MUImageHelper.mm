//
//  MUImageHelper.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 8/4/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "MUImageHelper.h"
#import "MUConstants.h"
#import "MUImageScaling.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CMTime.h>

static const CGFloat F_M_PI             = static_cast<CGFloat>( M_PI   );
static const CGFloat F_M_PI_DIV_2       = static_cast<CGFloat>( M_PI_2 );
static const CGFloat F_MINUS_M_PI_DIV_2 = -F_M_PI_DIV_2                 ;

@implementation MUImageHelper

+(CGFloat)getCompressionFactor:(MUImageQuality) uploadImageSize
{
    if (uploadImageSize == UPLODIMAGESIZE_ACTUAL)
    {
        return 1.f;
    }
    
    if (uploadImageSize == UPLODIMAGESIZE_MEDIUM)
    {
        return 0.8f;
    }
    
    return 0.6f;
}

+(UIImage*)resizeImageToSize:(UIImage*)image uploadImageSize:(MUImageQuality)uploadImageSize
{
    if (uploadImageSize == UPLODIMAGESIZE_ACTUAL)
    {
        return image;
    }
    
    CGSize size;
    
    size = [ MUConstants smallImageSize ];
    
    if (uploadImageSize == UPLODIMAGESIZE_MEDIUM)
    {
        size = [ MUConstants mediumImageSize ];
    }
    
    UIImage* result =  [ MUImageScaling scaleImage: image
                                             toSize: size ];
    
    return result;
}

+(void)saveUploadImageSize:(MUImageQuality)uploadImageSize
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:uploadImageSize forKey:@"UploadImageSize"];
    [defaults synchronize];
}

+(MUImageQuality)loadUploadImageSize
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSInteger imageSizeFromArchive = [defaults integerForKey: @"UploadImageSize"];
    
    return static_cast<MUImageQuality>( imageSizeFromArchive );
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
            transform = CGAffineTransformRotate(transform, F_M_PI);
            break;
            
        case UIImageOrientationLeft: // 2
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformRotate(transform, F_M_PI_DIV_2);
            break;
            
        case UIImageOrientationRight:// 3
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.width);
            transform = CGAffineTransformRotate(transform, F_MINUS_M_PI_DIV_2);
            break;
            
        case UIImageOrientationUp: // 0
        case UIImageOrientationUpMirrored:
            break;
    }
    
    CGContextRef ctx;

    size_t imageWidth  = static_cast<size_t>( ::lround( image.size.width ) );
    size_t imageHeight = static_cast<size_t>( ::lround( image.size.height ) );
    
    size_t contextWidth  = 0;
    size_t contextHeigth = 0;
    
    switch (orientation)
    {
        case UIImageOrientationRight:
        case UIImageOrientationLeft:
        case UIImageOrientationRightMirrored:
        case UIImageOrientationLeftMirrored:
        {
            contextWidth  = imageHeight;
            contextHeigth = imageWidth ;
            
            break;
        }
            
        default:
        {
            contextWidth  = imageWidth ;
            contextHeigth = imageHeight;
            
            break;
        }
    }
    
    ctx = CGBitmapContextCreate(NULL, contextWidth, contextHeigth,
                                CGImageGetBitsPerComponent(image.CGImage), 0,
                                CGImageGetColorSpace(image.CGImage),
                                CGImageGetBitmapInfo(image.CGImage));

    
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
