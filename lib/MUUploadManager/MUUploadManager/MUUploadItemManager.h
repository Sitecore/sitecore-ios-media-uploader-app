//
//  MUUploadItemManager.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by Igor on 16/12/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MUUploadItemStatus;

@interface MUUploadItemManager : NSObject

-(void)setStatus:(MUUploadItemStatus*)status forItemAtNumber:(NSNumber*)number;
-(MUUploadItemStatus*)statusForItemAtNumber:(NSNumber*)number;
-(void)clearAllStatuses;

@end
