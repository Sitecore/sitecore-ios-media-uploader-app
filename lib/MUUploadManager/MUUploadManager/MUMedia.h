//
//  MUMedia.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/29/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MUUploadManager/MUConstants.h>
#import <MUUploadManager/MUUploadItemStatus.h>

@class UIImage;

@interface MUMedia : NSObject

@property (nonatomic) UIImage*  thumbnail;
@property (nonatomic) NSString* name;
@property (nonatomic) NSString* description;
@property (nonatomic) NSDate*   dateTime;
@property (nonatomic) NSNumber* latitude;
@property (nonatomic) NSNumber* longitude;
@property (nonatomic) NSString* locationDescription;
@property (nonatomic) NSString* countryCode;
@property (nonatomic) NSString* cityCode;
@property (nonatomic) NSURL*    videoUrl;
@property (nonatomic) NSURL*    imageUrl;
@property (nonatomic) NSString* siteForUploadingId;
@property (nonatomic) MUImageQuality imageQuality;
@property (nonatomic) MUUploadItemStatus* uploadStatus;

-(instancetype)initWithObjectData:(NSString*)name
                         dateTime:(NSDate*)dateTime
                         latitude:(NSNumber*)latitude
                        longitude:(NSNumber*)longitude
              locationDescription:(NSString*)locationDescription
                      countryCode:(NSString*)countryCode
                         cityCode:(NSString*)cityCode
                         videoUrl:(NSURL*)videoUrl
                         imageUrl:(NSURL*)imageUrl
                        thumbnail:(UIImage*)thumbnail;

-(BOOL)isImage;
-(BOOL)isVideo;

@end