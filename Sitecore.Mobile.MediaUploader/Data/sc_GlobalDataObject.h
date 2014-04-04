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

@interface sc_GlobalDataObject : sc_AppDataObject

@property CLPlacemark *selectedPlaceMark;
@property NSMutableArray *mediaUpload;
@property bool isIpad;
@property ( nonatomic, readonly ) BOOL isOnline;
@property int IOS;
@property (nonatomic, readonly) sc_SitesManager *sitesManager;

- (void) loadMediaUpload;
- (void) saveMediaUpload;
- (void) addMediaUpload:(sc_Media*) media;
- (void)removeTmpVideoFileFromMediaItem:(sc_Media *)media;

+ (sc_GlobalDataObject*)getAppDataObject;

@end
