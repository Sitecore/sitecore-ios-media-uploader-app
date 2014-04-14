//
//  sc_Site.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/7/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_Site.h"
#import "sc_ImageHelper.h"

@interface sc_Site ()

@property ( nonatomic, readwrite ) BOOL selectedForBrowse;
@property ( nonatomic, readwrite ) BOOL selectedForUpload;

@end

@implementation sc_Site
{
    NSString *_siteStorage;
    NSString *_urlStrorage;
    
    NSString *_uploadFolderPathInsideMediaLibrary;
}

-(instancetype)copy
{
    //FIXME: @igk legacy
    NSLog(@"!!!!! SITE MUST NOT BE COPIED, LEGACY MANAGEMENT BUG");
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

+(NSString *)siteDefaultValue
{
    return @"/sitecore/shell";
}

+(NSString *)mediaLibraryDefaultPath
{
    return @"/sitecore/media library";
}

+(NSString *)mediaLibraryDefaultNameWithSlash:(BOOL)withSlash
{
    NSString *result = @"media library";
    
    if ( withSlash )
        result = [NSString stringWithFormat:@"%@/", result];
    
    return result;
}

-(instancetype)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithSiteUrl: (NSString *)siteUrl
                site: (NSString *)site
uploadFolderPathInsideMediaLibrary: (NSString *)uploadFolderPathInsideMediaLibrary
            username: (NSString *)username
            password: (NSString *)password
   selectedForBrowse: (BOOL)selectedForBrowse
   selectedForUpload: (BOOL)selectedForUpload
{
    self = [super init];
    if (nil != self)
    {
        NSAssert(siteUrl, @"siteUrl must exist");
        NSAssert(site, @"site must exist");
        NSAssert(uploadFolderPathInsideMediaLibrary, @"uploadFolderPathInsideMediaLibrary must exist");
        NSAssert(username, @"username must exist");
        NSAssert(password, @"password must exist");
        
        
        self.siteUrl = siteUrl;
        self.site = site;
        self.uploadFolderPathInsideMediaLibrary = uploadFolderPathInsideMediaLibrary;
        self.username = username;
        self.password = password;
        self->_selectedForBrowse = selectedForBrowse;
        self->_selectedForUpload = selectedForUpload;
    }
    
    return self;
}

-(NSString *)getFolderPathForUpload
{
    NSString *startingFolderPath = self.uploadFolderPathInsideMediaLibrary;
    
    NSString *rootFolderPath = [ [self class] mediaLibraryDefaultPath ];
    
    return [ NSString stringWithFormat:@"%@/%@", rootFolderPath, startingFolderPath];
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
        {
            self.site = [ NSString stringWithFormat:@"/%@", self.site ];
        }
    }
    
}

-(void)setSiteUrl:(NSString *)siteUrl
{
    self->_urlStrorage = siteUrl;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.siteProtocol forKey:@"siteProtocol"];
    [encoder encodeObject:self.siteUrl forKey:@"siteUrl"];
    [encoder encodeObject:self.site forKey:@"site"];
    [encoder encodeObject:self.uploadFolderPathInsideMediaLibrary forKey:@"uploadFolderPathInsideMediaLibrary"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.password forKey:@"password"];
    [encoder encodeBool:self->_selectedForBrowse forKey:@"selectedForBrowse"];
    [encoder encodeBool:self->_selectedForUpload forKey:@"selectedForUpdate"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self)
    {
        self.siteProtocol                       = [decoder decodeObjectForKey:@"siteProtocol"];
        self.siteUrl                            = [decoder decodeObjectForKey:@"siteUrl"];
        self.site                               = [decoder decodeObjectForKey:@"site"];
        self.uploadFolderPathInsideMediaLibrary = [decoder decodeObjectForKey:@"uploadFolderPathInsideMediaLibrary"];
        self.username                           = [decoder decodeObjectForKey:@"username"];
        self.password                           = [decoder decodeObjectForKey:@"password"];
        self->_selectedForBrowse                = [decoder decodeBoolForKey:@"selectedForBrowse"];
        self->_selectedForUpload                = [decoder decodeBoolForKey:@"selectedForUpdate"];
    }
    
    return self;
}

-(NSString*)description
{
    NSString* parentDescription = [ super description ];
    
    static NSString* SITE_FORMAT =
        @"Instance      : %@ \n"
        @"Site          : %@ \n"
        @"Login         : %@ \n"
        @"Upload Folder : %@ \n";
    
    NSString* result = [ NSString stringWithFormat: SITE_FORMAT, self.siteUrl, self.site, self.username, self.uploadFolderPathInsideMediaLibrary ];
    
    
    return [ NSString stringWithFormat: @"%@ \n %@", parentDescription, result ];
}

-(instancetype)copyWithZone:(NSZone *)zone
{
    sc_Site *copy = [[[self class] allocWithZone:zone] initWithSiteUrl: self.siteUrl
                                                                  site: self.site
                                    uploadFolderPathInsideMediaLibrary: self.uploadFolderPathInsideMediaLibrary
                                                              username: self.username
                                                              password: self.password
                                                     selectedForBrowse: self.selectedForBrowse
                                                     selectedForUpload: self.selectedForUpload ];
    NSAssert( copy, @"bad copy");
    return copy;
}

-(BOOL)isEqual:(sc_Site *)object
{
    //following fields must not be used for sites comparing: username, password, selectedForBrowse, selectedForUpdate
    if ( self == object )
    {
        return YES;
    }
    
    return (
               [self.siteUrl                            isEqualToString: object.siteUrl]
            && [self.site                               isEqualToString: object.site]
            && [self.uploadFolderPathInsideMediaLibrary isEqualToString: object.uploadFolderPathInsideMediaLibrary]
            );

}

-(NSUInteger)hash
{
    //following fields must not be used for hash calculating: username, password, selectedForBrowse, selectedForUpdate
    
    NSUInteger urlHash = [self.siteUrl hash];
    NSUInteger siteHash = [self.site hash];
    NSUInteger uploadFolderPathInsideMediaLibraryHash = [self.uploadFolderPathInsideMediaLibrary hash];
    
    return ( urlHash + siteHash + uploadFolderPathInsideMediaLibraryHash );
}

-(NSString *)uploadFolderPathInsideMediaLibrary
{
    if ( self->_uploadFolderPathInsideMediaLibrary == nil )
    {
        return @"";
    }
    
    return self->_uploadFolderPathInsideMediaLibrary;
    
}

-(void)setUploadFolderPathInsideMediaLibrary:(NSString *)uploadFolderPathInsideMediaLibrary
{
    NSString *mediaLibraryPath = [ [ self class ] mediaLibraryDefaultPath ];
    if ( [ uploadFolderPathInsideMediaLibrary hasPrefix: mediaLibraryPath ] )
    {
        NSUInteger symbolsCountToTruncate = [ mediaLibraryPath length ] + 1;
        
        if ( symbolsCountToTruncate >= [ uploadFolderPathInsideMediaLibrary length ] )
        {
            self->_uploadFolderPathInsideMediaLibrary = @"";
            return;
        }
        
        self->_uploadFolderPathInsideMediaLibrary = [ uploadFolderPathInsideMediaLibrary substringFromIndex: symbolsCountToTruncate ];
        return;
    }
    
    self->_uploadFolderPathInsideMediaLibrary = uploadFolderPathInsideMediaLibrary;
}

+(instancetype)emptySite
{
#if DEBUG
    //scmobileteam.sitecoretest.net
    return [ [self alloc] initWithSiteUrl: @"mobiledev1ua1.dk.sitecore.net:722/"
                                     site: @"sitecore/shell"
       uploadFolderPathInsideMediaLibrary: @""
                                 username: @"admin"
                                 password: @"b"
                        selectedForBrowse: NO
                        selectedForUpload: YES ];
    
#endif
    
    return [ [self alloc] initWithSiteUrl: @""
                                     site: [ self siteDefaultValue ]
       uploadFolderPathInsideMediaLibrary: @""
                                 username: @""
                                 password: @""
                        selectedForBrowse: NO
                        selectedForUpload: YES ];
}

@end