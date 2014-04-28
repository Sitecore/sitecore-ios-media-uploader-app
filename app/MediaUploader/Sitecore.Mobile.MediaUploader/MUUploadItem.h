//
//  MUUploadItem.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 7/30/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MUMedia;


@interface MUUploadItem : NSObject

@property (nonatomic) MUMedia* mediaItem;
@property (nonatomic) NSData* data;

-(instancetype)initWithObjectData:(MUMedia*)mediaItem
                             data:(NSData*)data;

@property (nonatomic, readonly) BOOL isImage;
@property (nonatomic, readonly) BOOL isVideo;
@property (nonatomic, readonly) NSString* fileName;
@property (nonatomic, readonly) NSString* itemTemplate;
@property (nonatomic, readonly) NSString* contentType;
@property (nonatomic, readonly) NSURL* assetURL;

@end
