//
//  MUUploadItemStatus.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by Igor on 30/12/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "MUUploadItemStatus.h"

@implementation MUUploadItemStatus

-(NSString*)description
{
    if ( self.statusId == errorStatus )
        return self->_description;
    
    return nil;
}

-(NSString*)localizedDescription
{
    return NSLocalizedString(self.description, nil);
}

@end
