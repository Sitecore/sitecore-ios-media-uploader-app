//
//  MUMedia.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/29/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "MUMedia.h"
#import "MUConstants.h"
#import "MUImageHelper.h"


@interface MUMedia ()

@end

@implementation MUMedia

-(instancetype)initWithObjectData:(NSString*)name
                         dateTime:(NSDate*)dateTime
                         locationInfo:(id<MULocationInfo>)locationInfo
                         videoUrl:(NSURL*)videoUrl
                         imageUrl:(NSURL*)imageUrl
                        thumbnail:(UIImage*)thumbnail
{
    self = [super init];
    if (self)
    {
        self->_name = name;
        self->_dateTime = dateTime;
        self->_locationInfo = locationInfo;
        self->_videoUrl = videoUrl;
        self->_imageUrl = imageUrl;
        self->_thumbnail = thumbnail;
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:  _name                forKey: @"name"             ];
    [encoder encodeObject:  _dateTime            forKey: @"dateTime"         ];
    [encoder encodeObject:  _videoUrl            forKey: @"videoUrl"         ];
    [encoder encodeObject:  _imageUrl            forKey: @"imageUrl"         ];
    [encoder encodeObject:  _thumbnail           forKey: @"thumbnail"        ];
    [encoder encodeObject:  _siteForUploadingId  forKey: @"siteForUploading" ];
    [encoder encodeObject:  _uploadStatus        forKey: @"uploadStatus"     ];
    [encoder encodeObject:  _locationInfo        forKey: @"locationInfo"     ];
}

-(instancetype)initWithCoder:(NSCoder*)decoder
{
    self = [super init];
    if (self)
    {
        self.name                = [decoder decodeObjectForKey:  @"name"             ];
        self.dateTime            = [decoder decodeObjectForKey:  @"dateTime"         ];
        self.videoUrl            = [decoder decodeObjectForKey:  @"videoUrl"         ];
        self.imageUrl            = [decoder decodeObjectForKey:  @"imageUrl"         ];
        self.thumbnail           = [decoder decodeObjectForKey:  @"thumbnail"        ];
        self.siteForUploadingId  = [decoder decodeObjectForKey:  @"siteForUploading" ];
        self.uploadStatus        = [decoder decodeObjectForKey:  @"uploadStatus"     ];
        self.locationInfo        = [decoder decodeObjectForKey:  @"locationInfo"     ];
    }
    
    return self;
}

-(BOOL)isImage
{
    return self.imageUrl != nil;
}

-(BOOL)isVideo
{
    return self.videoUrl != nil;
}

-(void)setImageUrl:(NSURL *)imageUrl
{
    if ( imageUrl != nil )
    {
        self->_videoUrl = nil;
        self->_imageUrl = imageUrl;
    }
}

-(void)setVideoUrl:(NSURL *)videoUrl
{
    if ( videoUrl != nil )
    {
        self->_imageUrl = nil;
        self->_videoUrl = videoUrl;
    }
}

-(MUUploadItemStatus *)uploadStatus
{
    if ( self->_uploadStatus == nil )
    {
        self->_uploadStatus = [ MUUploadItemStatus new ];
        self->_uploadStatus.statusId = READY_FOR_UPLOAD;
    }
    
    return self->_uploadStatus;
}

@end
