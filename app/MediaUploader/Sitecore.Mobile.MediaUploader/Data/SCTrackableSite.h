//
//  SCTrackableSite.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by Igor on 16/04/14.
//  Copyright (c) 2014 Sitecore. All rights reserved.
//

//#import "SCSite.h"




#import <Sitecore.Mobile.MediaUploader/Tracking/MUTrackable.h>

@interface SCTrackableSite : SCSite
<
MUTrackableObject,

MUUploadSettings,
MUUploadSettingsRecordState,
MUUploadSettings_Legacy
>

@end
