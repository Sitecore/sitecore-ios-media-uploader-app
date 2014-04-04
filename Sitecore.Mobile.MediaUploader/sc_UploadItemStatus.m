//
//  sc_UploadItemStatus.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by Igor on 30/12/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_UploadItemStatus.h"

@implementation sc_UploadItemStatus

-(NSString *)description
{
    if( self.statusId == errorStatus )
        return self->_description;
    
    return nil;
}

-(NSString *)localizedDescription
{
    return NSLocalizedString(self.description, nil);
}

@end
