//
//  sc_Site.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/7/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_Site.h"
#import "sc_ImageHelper.h"

@implementation sc_Site
{
    NSString *_siteStorage;
    NSString *_urlStrorage;
}

+(NSString *)siteDefaultValue
{
    return @"/sitecore/shell";
}

+(NSString *)mediaLibraryDefaultID
{
    return @"{3D6658D8-A0BF-4E75-B3E2-D050FABCF4E1}";
}

+(NSString *)mediaLibraryDefaultNameWithSlash:(BOOL)withSlash
{
    NSString *result = @"media library";
    
    if ( withSlash )
        result = [NSString stringWithFormat:@"%@/", result];
    
    return result;
}

-(id)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(id)initWithSiteUrl: (NSString *)siteUrl
                site: (NSString *)site
uploadFolderPathInsideMediaLibrary: (NSString *)uploadFolderPathInsideMediaLibrary
      uploadFolderId: (NSString *)uploadFolderId
            username: (NSString *)username
            password: (NSString *)password
   selectedForBrowse: (BOOL)selectedForBrowse
   selectedForUpdate: (BOOL)selectedForUpdate
{
    self = [super init];
    if (self)
    {
        NSAssert(siteUrl, @"siteUrl must exist");
        NSAssert(site, @"site must exist");
        NSAssert(uploadFolderPathInsideMediaLibrary, @"uploadFolderPathInsideMediaLibrary must exist");
        NSAssert(uploadFolderId, @"uploadFolderId must exist");
        NSAssert(username, @"username must exist");
        NSAssert(password, @"password must exist");
        
        self.index = [sc_ImageHelper getUUID];
        
        self.siteUrl = siteUrl;
        self.site = site;
        
        self.uploadFolderPathInsideMediaLibrary = uploadFolderPathInsideMediaLibrary;
        self.uploadFolderId = uploadFolderId;
        self.username = username;
        self.password = password;
        self.selectedForBrowse = selectedForBrowse;
        self.selectedForUpdate = selectedForUpdate;
    }
    
    return self;
}

-(NSString *)site
{
    return [ self->_siteStorage stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding ];
}

-(NSString *)siteUrl
{
    return [ self->_urlStrorage stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding ];
}

-(void)setSite:(NSString *)site
{
    if ( site == nil || [ site isEqualToString:@"" ] )
    {
        self->_siteStorage = @"";
    }
    else
    {
        self->_siteStorage = site;
        if ( ![ self.site hasPrefix:@"/"] )
            self.site = [ NSString stringWithFormat:@"/%@", self.site ];
    }
    
}

-(void)setSiteUrl:(NSString *)siteUrl
{
    self->_urlStrorage = siteUrl;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.index forKey:@"index"];
    [encoder encodeObject:self.siteUrl forKey:@"siteUrl"];
    [encoder encodeObject:self.site forKey:@"site"];
    [encoder encodeObject:self.uploadFolderPathInsideMediaLibrary forKey:@"uploadFolderPathInsideMediaLibrary"];
    [encoder encodeObject:self.uploadFolderId forKey:@"uploadFolderId"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.password forKey:@"password"];
    [encoder encodeBool:self.selectedForBrowse forKey:@"selectedForBrowse"];
    [encoder encodeBool:self.selectedForUpdate forKey:@"selectedForUpdate"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self)
    {
        self.index = [decoder decodeObjectForKey:@"index"];
        self.siteUrl = [decoder decodeObjectForKey:@"siteUrl"];
        self.site = [decoder decodeObjectForKey:@"site"];
        self.uploadFolderPathInsideMediaLibrary = [decoder decodeObjectForKey:@"uploadFolderPathInsideMediaLibrary"];
        self.uploadFolderId = [decoder decodeObjectForKey:@"uploadFolderId"];
        self.username = [decoder decodeObjectForKey:@"username"];
        self.password = [decoder decodeObjectForKey:@"password"];
        self.selectedForBrowse = [decoder decodeBoolForKey:@"selectedForBrowse"];
        self.selectedForUpdate = [decoder decodeBoolForKey:@"selectedForUpdate"];
    }
    
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    sc_Site *copy = [[[self class] allocWithZone:zone] initWithSiteUrl: self.siteUrl
                                                                  site: self.site
                                    uploadFolderPathInsideMediaLibrary: self.uploadFolderPathInsideMediaLibrary
                                                        uploadFolderId: self.uploadFolderId
                                                              username: self.username
                                                              password: self.password
                                                     selectedForBrowse: self.selectedForBrowse
                                                     selectedForUpdate: self.selectedForUpdate ];
    NSAssert( copy, @"bad copy");
    return copy;
}

-(void)setUploadFolderId:(NSString *)uploadFolderId
{
    if ( uploadFolderId == nil )
    {
        self->_uploadFolderId = @"";
        return;
    }
    
    self->_uploadFolderId = uploadFolderId;
}

-(BOOL)isEqual:(sc_Site *)object
{
    //following fields must not be used for sites comparing: username, password, selectedForBrowse, selectedForUpdate
    
    NSString *defaultFolderID = [ [ self class ] mediaLibraryDefaultID ];
    BOOL folderIDIsEqual =
    [ self.uploadFolderId isEqualToString: object.uploadFolderId ] ||
    ( [ self.uploadFolderId isEqualToString:@"" ] && [ object.uploadFolderId isEqualToString: defaultFolderID ] ) ||
    ( [ self.uploadFolderId isEqualToString:defaultFolderID ] && [ object.uploadFolderId isEqualToString: @"" ] );
    
    return (
               [self.siteUrl isEqualToString: object.siteUrl]
            && [self.site isEqualToString: object.site]
            && [self.uploadFolderPathInsideMediaLibrary isEqualToString: object.uploadFolderPathInsideMediaLibrary]
            && folderIDIsEqual
            );

}

-(NSUInteger)hash
{
    //following fields must not be used for hash calculating: username, password, selectedForBrowse, selectedForUpdate
    
    NSUInteger urlHash = [self.siteUrl hash];
    NSUInteger siteHash = [self.site hash];
    NSUInteger uploadFolderPathInsideMediaLibraryHash = [self.uploadFolderPathInsideMediaLibrary hash];
    NSUInteger uploadFolderIdHash = [self.uploadFolderId hash];
    
    return ( urlHash + siteHash + uploadFolderPathInsideMediaLibraryHash + uploadFolderIdHash );
}

-(NSString *)uploadFolderPathInsideMediaLibrary
{
    if ( self->_uploadFolderPathInsideMediaLibrary == nil )
    {
        return @"";
    }
    
    return self->_uploadFolderPathInsideMediaLibrary;
}

@end