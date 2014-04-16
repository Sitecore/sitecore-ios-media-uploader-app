//
//  sc_ItemHelper.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 8/5/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, sc_CellType)
{
    UnknownCellType = 0,
	ArrowCellType,
	FolderCellType,
	ImageCellType
};


@interface sc_ItemHelper : NSObject

+(SCApiSession*)getContext:(SCSite*)site;
+(NSString*)getDefaultDatabase;
+(NSString*)formatUploadFolder:(SCSite*)site;
+(NSString*)getPath:(NSString*)itemId;
+(NSString*)itemType:(SCItem*)item;
+(sc_CellType)scItemType:(SCItem*)item;
+(NSString*)generateItemName:(NSString*)fileName;

@end
