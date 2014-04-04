//
//  sc_Media.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/29/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

@class sc_Site;

@interface sc_Media : NSObject
@property  NSString *index;
@property  UIImage *thumbnail;
@property  NSString *name;
@property  NSString *description;
@property  NSDate *dateTime;
@property  NSNumber *latitude;
@property  NSNumber *longitude;
@property  NSString *locationDescription;
@property  NSString *countryCode;
@property  NSString *cityCode;
@property  NSURL *videoUrl;
@property  NSURL *imageUrl;
@property  NSInteger status;
@property  sc_Site *siteForUploading;


-(id)initWithObjectData:(NSString *)name
               dateTime:(NSDate *) dateTime
               latitude:(NSNumber *) latitude
              longitude:(NSNumber *) longitude
    locationDescription:(NSString *) locationDescription
            countryCode:(NSString *) countryCode
               cityCode:(NSString *) cityCode
               videoUrl:(NSURL *) videoUrl
               imageUrl:(NSURL *) imageUrl
                 status:(NSInteger)status
              thumbnail:(UIImage*) thumbnail;

-(BOOL)isImage;
-(BOOL)isVideo;

@end