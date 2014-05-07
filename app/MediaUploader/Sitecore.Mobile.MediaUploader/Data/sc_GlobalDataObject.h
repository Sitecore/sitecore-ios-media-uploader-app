//
//  sc_GlobaldataObject.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/8/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class SCSitesManager;
@class MUItemsForUploadManager;


@interface sc_GlobalDataObject : NSObject

@property ( nonatomic ) CLPlacemark* selectedPlaceMark;

@property ( nonatomic ) BOOL isIpad;
@property ( nonatomic, readonly ) BOOL isOnline;
@property ( nonatomic ) int IOS;


@property (nonatomic, readonly) SCSitesManager* sitesManager;
@property (nonatomic, readonly) MUItemsForUploadManager* uploadItemsManager;

+(sc_GlobalDataObject*)getAppDataObject;

+(NSString*)applicationDocumentsDir;

@end
