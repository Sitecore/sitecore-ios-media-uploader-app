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
                         latitude:(NSNumber*)latitude
                        longitude:(NSNumber*)longitude
              locationDescription:(NSString*)locationDescription
                      countryCode:(NSString*)countryCode
                         cityCode:(NSString*)cityCode
                         videoUrl:(NSURL*)videoUrl
                         imageUrl:(NSURL*)imageUrl
                        thumbnail:(UIImage*)thumbnail
{
    self = [super init];
    if (self)
    {
        _name = name;
        _dateTime = dateTime;
        _latitude = latitude;
        _longitude = longitude;
        _locationDescription = locationDescription;
        _countryCode = countryCode;
        _cityCode = cityCode;
        _videoUrl = videoUrl;
        _imageUrl = imageUrl;
        _thumbnail = thumbnail;
      }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:  _name                forKey: @"name"                ];
    [encoder encodeObject:  _dateTime            forKey: @"dateTime"            ];
    [encoder encodeObject:  _latitude            forKey: @"latitude"            ];
    [encoder encodeObject:  _longitude           forKey: @"longitude"           ];
    [encoder encodeObject:  _locationDescription forKey: @"locationDescription" ];
    [encoder encodeObject:  _countryCode         forKey: @"countryCode"         ];
    [encoder encodeObject:  _cityCode            forKey: @"cityCode"            ];
    [encoder encodeObject:  _videoUrl            forKey: @"videoUrl"            ];
    [encoder encodeObject:  _imageUrl            forKey: @"imageUrl"            ];
    [encoder encodeObject:  _thumbnail           forKey: @"thumbnail"           ];
    [encoder encodeObject:  _siteForUploadingId  forKey: @"siteForUploading"    ];
}

-(instancetype)initWithCoder:(NSCoder*)decoder
{
    self = [super init];
    if (self)
    {
        self.name                = [decoder decodeObjectForKey:  @"name"                ];
        self.dateTime            = [decoder decodeObjectForKey:  @"dateTime"            ];
        self.latitude            = [decoder decodeObjectForKey:  @"latitude"            ];
        self.longitude           = [decoder decodeObjectForKey:  @"longitude"           ];
        self.locationDescription = [decoder decodeObjectForKey:  @"locationDescription" ];
        self.countryCode         = [decoder decodeObjectForKey:  @"countryCode"         ];
        self.cityCode            = [decoder decodeObjectForKey:  @"cityCode"            ];
        self.videoUrl            = [decoder decodeObjectForKey:  @"videoUrl"            ];
        self.imageUrl            = [decoder decodeObjectForKey:  @"imageUrl"            ];
        self.thumbnail           = [decoder decodeObjectForKey:  @"thumbnail"           ];
        self.siteForUploadingId  = [decoder decodeObjectForKey:  @"siteForUploading"    ];
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