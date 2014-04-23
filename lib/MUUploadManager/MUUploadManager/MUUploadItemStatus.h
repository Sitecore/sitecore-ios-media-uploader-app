//
//  MUUploadItemStatus.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by Igor on 30/12/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MUUploadItemStatusType)
{
    inProgressStatus = 0,
	errorStatus,
	doneStatus,
    canceledStatus
};

@interface MUUploadItemStatus : NSObject

@property (nonatomic) MUUploadItemStatusType statusId;
@property (nonatomic) NSString* description;
@property (nonatomic, readonly) NSString* localizedDescription;

@end
