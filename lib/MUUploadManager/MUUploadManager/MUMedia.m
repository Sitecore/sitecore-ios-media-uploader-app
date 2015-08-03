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
#import "MUUploadItemStatus.h"
#import "MUMedia+Private.h"

@interface MUMedia ()

@property (nonatomic) MUUploadItemStatus* uploadStatusData;

@end


@implementation MUMedia
@dynamic description;

-(instancetype)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithName:(NSString*)name
                   dateTime:(NSDate*)dateTime
               locationInfo:(id<MULocationInfo>)locationInfo
                   videoUrl:(NSURL*)videoUrl
                   imageUrl:(NSURL*)imageUrl
                  thumbnail:(UIImage*)thumbnail
{
    self = [super init];
    if ( nil == self)
    {
        return nil;
    }
    
    self->_name = name;
    self->_dateTime = dateTime;
    self->_locationInfo = locationInfo;
    self->_videoUrl = videoUrl;
    self->_imageUrl = imageUrl;
    self->_thumbnail = thumbnail;
    
    return self;
}

-(void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:  _name                 forKey: @"name"             ];
    [encoder encodeObject:  _dateTime             forKey: @"dateTime"         ];
    [encoder encodeObject:  _videoUrl             forKey: @"videoUrl"         ];
    [encoder encodeObject:  _imageUrl             forKey: @"imageUrl"         ];
    [encoder encodeObject:  _thumbnail            forKey: @"thumbnail"        ];
    [encoder encodeObject:  _siteForUploadingId   forKey: @"siteForUploading" ];
    [encoder encodeObject:  self.uploadStatusData forKey: @"uploadStatusData" ];
    [encoder encodeObject:  _locationInfo         forKey: @"locationInfo"     ];
}

-(instancetype)initWithCoder:(NSCoder*)decoder
{
    self = [super init];
    if ( nil == self)
    {
        return nil;
    }

    self.name                = [decoder decodeObjectForKey:  @"name"             ];
    self.dateTime            = [decoder decodeObjectForKey:  @"dateTime"         ];
    self.videoUrl            = [decoder decodeObjectForKey:  @"videoUrl"         ];
    self.imageUrl            = [decoder decodeObjectForKey:  @"imageUrl"         ];
    self.thumbnail           = [decoder decodeObjectForKey:  @"thumbnail"        ];
    self.siteForUploadingId  = [decoder decodeObjectForKey:  @"siteForUploading" ];
    self.uploadStatusData    = [decoder decodeObjectForKey:  @"uploadStatusData" ];
    self.locationInfo        = [decoder decodeObjectForKey:  @"locationInfo"     ];
    
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

-(void)setImageUrl:(NSURL*)imageUrl
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

-(MUUploadItemStatus*)uploadStatusData
{
    if ( nil == self->_uploadStatusData )
    {
        self->_uploadStatusData = [ [ MUUploadItemStatus alloc ] initWithStatusId: READY_FOR_UPLOAD ];
    }
    
    return self->_uploadStatusData;
}

@end
