//
//  sc_UploadItem.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 7/30/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_UploadItem.h"
#import "sc_Constants.h"

@implementation sc_UploadItem

-(instancetype)initWithObjectData:(sc_Media*)mediaItem data:(NSData*)data
{
    self = [super init];
    if (self)
    {
        _mediaItem = mediaItem;
        _data = data;        
    }
    
    return self;
}

-(BOOL)isImage
{
    return [ self.mediaItem isImage ];
}

-(BOOL)isVideo
{
    return [ self.mediaItem isVideo ];
}

-(NSString*)fileName
{
    if ( self.isVideo )
    {
        return [ NSString stringWithFormat:@"%@.mov", self.mediaItem.name ];
    }
    
    if ( self.isImage )
    {
        return [ NSString stringWithFormat:@"%@.jpeg", self.mediaItem.name ];
    }
    
    return @"";
}

-(NSString*)itemTemplate
{
    if ( self.isVideo )
    {
       return VIDEO_TEMPLATE_PATH;
    }
    
    if ( self.isImage )
    {
        return IMAGE_JPEG_TEMPLATE_PATH;
    }
    
    return @"";
}

-(NSString*)contentType
{
    //https://support.sitecore.net/client/ViewItem.aspx?type=defects&id=401301
    //QA and devs: please note that "Content-type = image/jpeg" is not acceptable. It needs to be "multipart/form-data" according to the spec.
    
//    if ( self.isVideo )
//    {
//        return @"video/mp4";
//    }
//    
//    if ( self.isImage )
//    {
//        return @"image/jpeg";
//    }
    
    return @"multipart/form-data";
}

-(NSURL*)assetURL
{
    if ( self.isVideo )
    {
        return self.mediaItem.videoUrl;
    }
    
    if ( self.isImage )
    {
        return self.mediaItem.imageUrl;
    }
    
    return nil;
}

@end
