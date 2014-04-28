#import <Foundation/Foundation.h>

#import <SCInstanceStorage/SessionInfo/MUUploadSettings.h>
#import <SCInstanceStorage/SessionInfo/MUUploadSettings_Legacy.h>
#import <SCInstanceStorage/SessionInfo/MUUploadSettingsRecordState.h>

@interface SCSite : NSObject
<
    MUUploadSettings,
    MUUploadSettingsRecordState,
    MUUploadSettings_Legacy
>

@property ( nonatomic, readonly ) NSString* siteProtocol;
@property ( nonatomic, readonly ) NSString* siteUrl;
@property ( nonatomic, readonly ) NSString* site;
@property ( nonatomic, readonly ) NSString* uploadFolderPathInsideMediaLibrary;

@property ( nonatomic, readonly ) NSString* siteId;

@property ( nonatomic, readonly ) NSString* username;
@property ( nonatomic, readonly ) NSString* password;
@property ( nonatomic, readonly ) BOOL selectedForBrowse;
@property ( nonatomic, readonly ) BOOL selectedForUpload;


/**
 Unsupported initializer
 */
-(instancetype)init __attribute__((noreturn));

/**
 Construncts a site with empty fields for the "awakeFromNib:" method.

 WARNING : Should be deprecated
 */
+(instancetype)emptySite;


/**
 A designated initializer
 */
-(instancetype)initWithSiteUrl:(NSString*)siteUrl
                          site:(NSString*)site
uploadFolderPathInsideMediaLibrary:(NSString*)uploadFolderPathInsideMediaLibrary
                      username:(NSString*)username
                      password:(NSString*)password
             selectedForBrowse:(BOOL)selectedForBrowse
             selectedForUpload:(BOOL)selectedForUpload;

-(NSString*)getFolderPathForUpload;


+(NSString*)siteDefaultValue;
+(NSString*)mediaLibraryDefaultPath;
+(NSString*)mediaLibraryDefaultNameWithSlash:(BOOL)withSlash;

@end
