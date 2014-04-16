//
//  sc_GlobaldataObject.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/8/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "sc_AppDataObject.h"

@class SCSitesManager;
@class sc_ItemsForUploadManager;

@interface sc_GlobalDataObject : sc_AppDataObject


@property ( nonatomic ) CLPlacemark* selectedPlaceMark;

@property ( nonatomic ) bool isIpad;
@property ( nonatomic, readonly ) BOOL isOnline;
@property ( nonatomic ) int IOS;


@property (nonatomic, readonly) SCSitesManager* sitesManager;
@property (nonatomic, readonly) sc_ItemsForUploadManager* uploadItemsManager;

+(sc_GlobalDataObject*)getAppDataObject;

@end
