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
#import <MUUploadManager/MULocationInfo.h>

@class UIImage;

@interface MUMedia : NSObject

@property (nonatomic) UIImage*  thumbnail;
@property (nonatomic) NSString* name;
@property (nonatomic) NSString* description;
@property (nonatomic) NSDate*   dateTime;
@property (nonatomic) NSURL*    videoUrl;
@property (nonatomic) NSURL*    imageUrl;
@property (nonatomic) NSString* siteForUploadingId;

@property (nonatomic) id<MULocationInfo> locationInfo;
@property (nonatomic) MUImageQuality imageQuality;
@property (nonatomic, readonly) MUUploadItemStatus* uploadStatusData;

-(instancetype)initWithName:(NSString*)name
                   dateTime:(NSDate*)dateTime
               locationInfo:(id<MULocationInfo>)locationInfo
                   videoUrl:(NSURL*)videoUrl
                   imageUrl:(NSURL*)imageUrl
                  thumbnail:(UIImage*)thumbnail;

-(BOOL)isImage;
-(BOOL)isVideo;

@end
