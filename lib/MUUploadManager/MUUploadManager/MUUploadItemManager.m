//
//  MUUploadItemManager.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by Igor on 16/12/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "MUUploadItemManager.h"
#import "MUUploadItemStatus.h"

@implementation MUUploadItemManager
{
    NSMutableDictionary* _statusStorage;
}

-(id)init
{
    if ( self = [ super init ] )
    {
        self->_statusStorage = [ NSMutableDictionary new ];
    }
    
    return self;
}

-(void)setStatus:(MUUploadItemStatus*)status forItemAtNumber:(NSNumber*)number
{
    [ self->_statusStorage setObject: status
                              forKey: number ];
}

-(MUUploadItemStatus*)statusForItemAtNumber:(NSNumber*)number
{
    MUUploadItemStatus *status = [ self->_statusStorage objectForKey: number ];
    
    if ( !status )
    {
        status = [ MUUploadItemStatus new ];
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
