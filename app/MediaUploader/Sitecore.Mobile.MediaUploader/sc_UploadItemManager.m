//
//  sc_UploadItemManager.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by Igor on 16/12/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_UploadItemManager.h"
#import "sc_UploadItemStatus.h"

@implementation sc_UploadItemManager
{
    NSMutableDictionary *_statusStorage;
}

-(id)init
{
    if ( self = [ super init ] )
    {
        self->_statusStorage = [ NSMutableDictionary new ];
    }
    
    return self;
}

-(void)setStatus:(sc_UploadItemStatus *)status forItemAtNumber:(NSNumber* )number
{
    [ self->_statusStorage setObject: status
                              forKey: number ];
}

-(sc_UploadItemStatus *)statusForItemAtNumber:(NSNumber* )number
{
    sc_UploadItemStatus *status = [ self->_statusStorage objectForKey: number ];
    
    if ( !status )
    {
        status = [ sc_UploadItemStatus new ];
        status.statusId = inProgressStatus;
        [ self setStatus: status forItemAtNumber: number ];
    }
    
    return status;
}

-(void)clearAllStatuses
{
    [ self->_statusStorage removeAllObjects ];
}

@end
