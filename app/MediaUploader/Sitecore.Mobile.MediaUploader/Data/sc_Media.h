//
//  sc_Media.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/29/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCSite;

@interface sc_Media : NSObject

@property  (nonatomic) NSString *index;
@property  (nonatomic) UIImage *thumbnail;
@property  (nonatomic) NSString *name;
@property  (nonatomic) NSString *description;
@property  (nonatomic) NSDate *dateTime;
@property  (nonatomic) NSNumber *latitude;
@property  (nonatomic) NSNumber *longitude;
@property  (nonatomic) NSString *locationDescription;
@property  (nonatomic) NSString *countryCode;
@property  (nonatomic) NSString *cityCode;
@property  (nonatomic) NSURL *videoUrl;
@property  (nonatomic) NSURL *imageUrl;
@property  (nonatomic) NSInteger status;
@property  (nonatomic) SCSite *siteForUploading;

-(id)initWithObjectData:(NSString *)name
               dateTime:(NSDate   *) dateTime
               latitude:(NSNumber *) latitude
              longitude:(NSNumber *) longitude
    locationDescription:(NSString *) locationDescription
            countryCode:(NSString *) countryCode
               cityCode:(NSString *) cityCode
               videoUrl:(NSURL *) videoUrl
               imageUrl:(NSURL *) imageUrl
                 status:(NSInteger)status
              thumbnail:(UIImage *) thumbnail;

-(BOOL)isImage;
-(BOOL)isVideo;

@end