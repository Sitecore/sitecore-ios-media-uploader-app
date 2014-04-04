//
//  sc_UploadItemStatus.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by Igor on 30/12/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, sc_UploadItemStatusType)
{
    inProgressStatus = 0,
	errorStatus,
	doneStatus,
    canceledStatus
};

@interface sc_UploadItemStatus : NSObject

@property(nonatomic) sc_UploadItemStatusType statusId;
@property(nonatomic) NSString *description;
@property(nonatomic, readonly) NSString *localizedDescription;

@end
