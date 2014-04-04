//
//  sc_Site.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/7/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sc_Site : NSObject

@property ( nonatomic ) NSString *index;
@property ( nonatomic ) NSString *siteUrl;
@property ( nonatomic ) NSString *site;
@property ( nonatomic ) NSString *uploadFolderPathInsideMediaLibrary;
@property ( nonatomic ) NSString *uploadFolderId;
@property ( nonatomic ) NSString *username;
@property ( nonatomic ) NSString *password;
@property ( nonatomic ) BOOL selectedForBrowse;
@property ( nonatomic ) BOOL selectedForUpdate;

-(id)initWithSiteUrl: (NSString *)siteUrl
                site: (NSString *)site
uploadFolderPathInsideMediaLibrary: (NSString *)uploadFolderPathInsideMediaLibrary
      uploadFolderId: (NSString *)uploadFolderId
            username: (NSString *)username
            password: (NSString *)password
   selectedForBrowse: (BOOL)selectedForBrowse
   selectedForUpdate: (BOOL)selectedForUpdate;

+(NSString *)siteDefaultValue;
+(NSString *)mediaLibraryDefaultID;
+(NSString *)mediaLibraryDefaultNameWithSlash:(BOOL)withSlash;
@end
