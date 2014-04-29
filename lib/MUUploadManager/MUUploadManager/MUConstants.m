#import "MUConstants.h"

NSString* const VIDEO_TEMPLATE_PATH      = @"System/Media/Unversioned/Video";
NSString* const IMAGE_TEMPLATE_PATH      = @"System/Media/Unversioned/Image";
NSString* const IMAGE_JPEG_TEMPLATE_PATH = @"System/Media/Unversioned/Jpeg";
NSString* const MEDIA_FOLDER_PATH        = @"System/Media/Media folder";
NSString* const ITEM_TEMPLATE_PATH       = @"System/Main section";

@implementation MUConstants

+(CGSize)mediumImageSize
{
    return CGSizeMake( 1024.f, 768.f );
}

+(CGSize)smallImageSize
{
    return CGSizeMake( 800.f, 600.f );
}

@end

