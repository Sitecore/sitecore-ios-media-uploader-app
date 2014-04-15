//
//  sc_GlobaldataObject.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/8/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sc_AppDataObject.h"
#import "sc_Site.h"
#import "sc_media.h"
#import "sc_SitesManager.h"
#import "sc_ItemsForUploadManager.h"

@interface sc_GlobalDataObject : sc_AppDataObject


@property ( nonatomic ) CLPlacemark *selectedPlaceMark;

@property ( nonatomic ) bool isIpad;
@property ( nonatomic, readonly ) BOOL isOnline;
@property ( nonatomic ) int IOS;


@property (nonatomic, readonly) sc_SitesManager *sitesManager;
@property (nonatomic, readonly) sc_ItemsForUploadManager *uploadItemsManager;

+ (sc_GlobalDataObject*)getAppDataObject;

@end
