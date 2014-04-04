//
//  sc_Media.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/29/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_Media.h"
#import "sc_Constants.h"
#import "sc_ImageHelper.h"

@interface sc_Media ()
@end

@implementation sc_Media

-(id)initWithObjectData:(NSString *) name
               dateTime:(NSDate *) dateTime
               latitude:(NSNumber *) latitude
              longitude:(NSNumber *) longitude
    locationDescription:(NSString *)locationDescription
            countryCode:(NSString *) countryCode
               cityCode:(NSString *) cityCode
               videoUrl:(NSURL*) videoUrl
               imageUrl:(NSURL*) imageUrl
                 status:(NSInteger) status
              thumbnail:(UIImage*) thumbnail
{
    self = [super init];
    if (self)
    {
        _index = [sc_ImageHelper getUUID];
        _name = name;
        _dateTime = dateTime;
        _latitude = latitude;
        _longitude = longitude;
        _locationDescription = locationDescription;
        _countryCode = countryCode;
        _cityCode = cityCode;
        _videoUrl = videoUrl;
        _imageUrl = imageUrl;
        _status = status;
        _thumbnail = thumbnail;
        
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject: _index               forKey:@"index"];
    [encoder encodeObject: _name                forKey:@"name"];
    [encoder encodeObject: _dateTime            forKey:@"dateTime"];
    [encoder encodeObject: _latitude            forKey:@"latitude"];
    [encoder encodeObject: _longitude           forKey:@"longitude"];
    [encoder encodeObject: _locationDescription forKey:@"locationDescription"];
    [encoder encodeObject: _countryCode         forKey:@"countryCode"];
    [encoder encodeObject: _cityCode            forKey:@"cityCode"];
    [encoder encodeObject: _videoUrl            forKey:@"videoUrl"];
    [encoder encodeObject: _imageUrl            forKey:@"imageUrl"];
    [encoder encodeInteger:_status              forKey:@"status"];
    [encoder encodeObject: _thumbnail           forKey:@"thumbnail"];
    [encoder encodeObject: _siteForUploading    forKey:@"siteForUploading"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self)
    {
        self.index               = [decoder decodeObjectForKey:@"index"];
        self.name                = [decoder decodeObjectForKey:@"name"];
        self.dateTime            = [decoder decodeObjectForKey:@"dateTime"];
        self.latitude            = [decoder decodeObjectForKey:@"latitude"];
        self.longitude           = [decoder decodeObjectForKey:@"longitude"];
        self.locationDescription = [decoder decodeObjectForKey:@"locationDescription"];
        self.countryCode         = [decoder decodeObjectForKey:@"countryCode"];
        self.cityCode            = [decoder decodeObjectForKey:@"cityCode"];
        self.videoUrl            = [decoder decodeObjectForKey:@"videoUrl"];
        self.imageUrl            = [decoder decodeObjectForKey:@"imageUrl"];
        self.status              = [decoder decodeIntegerForKey:@"status"];
        self.thumbnail           = [decoder decodeObjectForKey:@"thumbnail"];
        self.siteForUploading    = [decoder decodeObjectForKey:@"siteForUploading"];
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

@end