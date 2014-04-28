#import "SCSite.h"
#import "MUUploadSettingsStringFormatter.h"
#import "SCSite+Private.h"

@interface SCSite ()

@property ( nonatomic, readwrite ) BOOL selectedForBrowse;
@property ( nonatomic, readwrite ) BOOL selectedForUpload;

@property ( nonatomic, readwrite ) NSString* siteProtocol;
@property ( nonatomic, readwrite ) NSString* siteUrl;
@property ( nonatomic, readwrite ) NSString* site;
@property ( nonatomic, readwrite ) NSString* siteId;

@property ( nonatomic, readwrite ) NSString* username;
@property ( nonatomic, readwrite ) NSString* password;
@property ( nonatomic, readwrite ) NSString* uploadFolderPathInsideMediaLibrary;

@end

@implementation SCSite
{
    NSString* _siteStorage;
    NSString* _urlStrorage;
}

@synthesize uploadFolderPathInsideMediaLibrary = _uploadFolderPathInsideMediaLibrary;

+(NSString*)siteDefaultValue
{
    return @"/sitecore/shell";
}

+(NSString*)mediaLibraryDefaultPath
{
    return @"/sitecore/media library";
}

+(NSString*)mediaLibraryDefaultNameWithSlash:(BOOL)withSlash
{
    NSString* result = @"media library";
    
    if ( withSlash )
    {
        result = [NSString stringWithFormat:@"%@/", result];
    }
    
    return result;
}

-(instancetype)init __attribute__((noreturn))
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithSiteUrl:(NSString*)siteUrl
                          site:(NSString*)site
uploadFolderPathInsideMediaLibrary:(NSString*)uploadFolderPathInsideMediaLibrary
                      username:(NSString*)username
                      password:(NSString*)password
             selectedForBrowse:(BOOL)selectedForBrowse
             selectedForUpload:(BOOL)selectedForUpload
{
    NSParameterAssert( nil != siteUrl                            );
    NSParameterAssert( nil != site                               );
    NSParameterAssert( nil != uploadFolderPathInsideMediaLibrary );
    NSParameterAssert( nil != username                           );
    NSParameterAssert( nil != password                           );

    
    self = [super init];
    if ( nil != self )
    {
        [ self generateId ];
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

-(NSString*)getFolderPathForUpload
{
    NSString* startingFolderPath = self.uploadFolderPathInsideMediaLibrary;
    
    NSString* rootFolderPath = [ [self class] mediaLibraryDefaultPath ];
    
    return [ NSString stringWithFormat:@"%@/%@", rootFolderPath, startingFolderPath];
}

-(NSString*)site
{
    return [ self->_siteStorage stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding ];
}

-(NSString*)siteUrl
{
    return [ self->_urlStrorage stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding ];
}

-(void)setSite:(NSString*)site
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

-(void)setSiteUrl:(NSString*)siteUrl
{
    self->_urlStrorage = siteUrl;
}

-(void)setSiteId:(NSString *)siteId
{
    self->_siteId = siteId;
}

-(void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject: self.siteId forKey:@"siteId"];
    [encoder encodeObject: self.siteProtocol forKey:@"siteProtocol"];
    [encoder encodeObject: self.siteUrl forKey:@"siteUrl"];
    [encoder encodeObject: self.site forKey:@"site"];
    [encoder encodeObject: self.uploadFolderPathInsideMediaLibrary forKey:@"uploadFolderPathInsideMediaLibrary"];
    [encoder encodeObject: self.username forKey:@"username"];
    [encoder encodeObject: self.password forKey:@"password"];
    [encoder encodeBool: self->_selectedForBrowse forKey:@"selectedForBrowse"];
    [encoder encodeBool: self->_selectedForUpload forKey:@"selectedForUpdate"];
}

-(id)initWithCoder:(NSCoder*)decoder
{
    self = [super init];
    if ( nil != self )
    {
        self.siteId                             = [decoder decodeObjectForKey:@"siteId"];
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

-(id)copyWithZone:(NSZone*)zone
{
    SCSite *copy = [[[self class] allocWithZone:zone] initWithSiteUrl: self.siteUrl
                                                                  site: self.site
                                    uploadFolderPathInsideMediaLibrary: self.uploadFolderPathInsideMediaLibrary
                                                              username: self.username
                                                              password: self.password
                                                     selectedForBrowse: self.selectedForBrowse
                                                     selectedForUpload: self.selectedForUpload ];
    NSParameterAssert( nil != copy );
    copy.siteId = self.siteId;
    return copy;
}

-(BOOL)isEqual:(SCSite*)object
{
    //following fields must not be used for sites comparing: username, password, selectedForBrowse, selectedForUpdate
    if ( self == object )
    {
        return YES;
    }
    
    
    NSParameterAssert( nil != self.siteUrl   );
    NSParameterAssert( nil != object.siteUrl );

    NSComparisonResult compareSiteUrl = [ self.siteUrl compare: object.siteUrl
                                                       options: NSCaseInsensitiveSearch ];
    BOOL instanceMarches = ( NSOrderedSame == compareSiteUrl );
    
    
    
    BOOL siteMatches = NO;
    if ( nil == self.site && nil == object.site )
    {
        siteMatches = YES;
    }
    else
    {
        NSComparisonResult compareSitecoreSite = [ self.site compare: object.site
                                                             options: NSCaseInsensitiveSearch ];
        siteMatches = ( NSOrderedSame == compareSitecoreSite );
    }
    
    

    NSString* myMediaPath = self.uploadFolderPathInsideMediaLibrary;
    NSString* otherMediaPath = object.uploadFolderPathInsideMediaLibrary;

    NSParameterAssert( nil != myMediaPath    );
    NSParameterAssert( nil != otherMediaPath );
    NSComparisonResult compareMediaPath = [ myMediaPath compare: otherMediaPath
                                                        options: NSCaseInsensitiveSearch ];
    BOOL mediaPathMarches = ( NSOrderedSame == compareMediaPath );

    
    
    BOOL result =
        instanceMarches
        && siteMatches
        && mediaPathMarches;
    
    return result;
}

-(NSUInteger)hash
{
    //following fields must not be used for hash calculating: username, password, selectedForBrowse, selectedForUpdate
    
    NSUInteger urlHash = [self.siteUrl hash];
    NSUInteger siteHash = [self.site hash];
    NSUInteger uploadFolderPathInsideMediaLibraryHash = [self.uploadFolderPathInsideMediaLibrary hash];
    
    return ( urlHash + siteHash + uploadFolderPathInsideMediaLibraryHash );
}

-(NSString*)uploadFolderPathInsideMediaLibrary
{
    if ( self->_uploadFolderPathInsideMediaLibrary == nil )
    {
        return @"";
    }
    
    return self->_uploadFolderPathInsideMediaLibrary;
    
}

-(void)setUploadFolderPathInsideMediaLibrary:(NSString*)uploadFolderPathInsideMediaLibrary
{
    NSString* mediaLibraryPath = [ [ self class ] mediaLibraryDefaultPath ];
    
    
    NSLocale* posixLocale = [ [ NSLocale alloc ] initWithLocaleIdentifier: @"en_US_POSIX" ];
    NSString* capitalizedMediaLibraryPath = [ mediaLibraryPath uppercaseStringWithLocale: posixLocale ];
    NSString* capitalizedUploadFolder = [ uploadFolderPathInsideMediaLibrary uppercaseStringWithLocale: posixLocale ];
    
    
    if ( [ capitalizedUploadFolder hasPrefix: capitalizedMediaLibraryPath ] )
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

-(NSString*)description
{
    NSString* parentDescription = [ super description ];
    NSString* rootMediaPath = [ [ self class ] mediaLibraryDefaultPath ];
    
    MUUploadSettingsStringFormatter* formatter = [[ MUUploadSettingsStringFormatter alloc ] initWithRootMediaPath: rootMediaPath ];
    NSString* result = [ formatter formatSettings: self ];
    
    return [ NSString stringWithFormat: @"%@ \n %@", parentDescription, result ];
}

@end
