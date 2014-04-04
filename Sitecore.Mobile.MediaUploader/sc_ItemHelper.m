//
//  sc_ItemHelper.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 8/5/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_ItemHelper.h"
#import "sc_Site.h"
#import "sc_Constants.h"

@implementation sc_ItemHelper

+(NSString *)getDefaultDatabase
{
   //return @"web";
   return @"master";
}

+(SCApiSession *)getContext:(sc_Site *) site
{
    SCApiSession * session = [SCApiSession sessionWithHost: site.siteUrl
                                                     login: site.username
                                                  password: site.password];
    session.defaultSite = site.site;
    
    session.defaultDatabase = [self getDefaultDatabase];
    return session;
}

+(NSString *)formatUploadFolder:(sc_Site *) site
{
    if (site.uploadFolderPathInsideMediaLibrary.length == 0)
    {
        return [ sc_Site mediaLibraryDefaultNameWithSlash: NO ];
    }
    
    return [NSString stringWithFormat: @"%@%@", [ sc_Site mediaLibraryDefaultNameWithSlash: YES ], site.uploadFolderPathInsideMediaLibrary];
}

+(sc_CellType) scItemType: (SCItem *) item
{
    
    if ([ item.itemTemplate isEqualToString: MEDIA_FOLDER_PATH ] || [ item.itemTemplate isEqualToString: ITEM_TEMPLATE_PATH ])
    {
        return FolderCellType;
    }
    
    if ([ item.itemTemplate isEqualToString: IMAGE_JPEG_TEMPLATE_PATH ] || [ item.itemTemplate isEqualToString: IMAGE_TEMPLATE_PATH ])
    {
        return ImageCellType;
    }
    
    return UnknownCellType;
}

+(NSString *) itemType: (SCItem *) item
{
        
    if ([ item.itemTemplate isEqualToString: MEDIA_FOLDER_PATH ] || [ item.itemTemplate isEqualToString: ITEM_TEMPLATE_PATH ])
    {
        return @"folder";
    }
    
    if ([item.itemTemplate isEqualToString: IMAGE_JPEG_TEMPLATE_PATH ] || [item.itemTemplate isEqualToString:IMAGE_TEMPLATE_PATH ])
    {
        return @"image";
    }
    
    return @"unknown item type";
}

+(NSString *) getPath: (NSString *) itemId
{
    //remove { - } and add / to start
    return [NSString stringWithFormat:@"/%@", [[itemId componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"{-}"]] componentsJoinedByString: @""]];
}

+(NSString *)generateItemName:(NSString *) fileName
{
    NSDate *newDate;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:~ NSTimeZoneCalendarUnit fromDate:[NSDate date]];
    newDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    
    NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
    [dtF setDateFormat:@"yyyyMMddhhmms"];
    return [NSString stringWithFormat: @"%@_%@", fileName, [dtF stringFromDate:newDate]];
}

@end
