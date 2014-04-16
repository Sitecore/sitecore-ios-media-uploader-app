//
//  sc_GlobaldataObject.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/8/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_GlobalDataObject.h"
#import "sc_Media.h"
#import "sc_Constants.h"
#import "sc_ConnectivityHelper.h"
#import "sc_AppDelegateProtocol.h"

@implementation sc_GlobalDataObject

+(sc_GlobalDataObject*)getAppDataObject
{
    id<sc_AppDelegateProtocol> delegate = (id<sc_AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
    sc_GlobalDataObject* result = (sc_GlobalDataObject*)delegate.appDataObject;
    
    return result;
}

-(instancetype)init
{
    if ( self = [super init] )
    {
        self->_sitesManager = [ sc_SitesManager new ];
        self->_uploadItemsManager = [ sc_ItemsForUploadManager new ];
    }
    
    return self;
}


-(BOOL)isOnline
{
    return [sc_ConnectivityHelper connectedToInternet];
}

@end
