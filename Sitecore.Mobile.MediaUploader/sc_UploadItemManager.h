//
//  sc_UploadItemManager.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by Igor on 16/12/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

@class sc_UploadItemStatus;

@interface sc_UploadItemManager : NSObject

-(void)setStatus:(sc_UploadItemStatus *)status forItemAtNumber:(NSNumber *)number;
-(sc_UploadItemStatus *)statusForItemAtNumber:(NSNumber *)number;
-(void)clearAllStatuses;

@end
