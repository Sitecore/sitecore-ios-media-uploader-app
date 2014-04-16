#import <Foundation/Foundation.h>

@interface SCSite : NSObject

@property ( nonatomic ) NSString* siteProtocol;
@property ( nonatomic ) NSString* siteUrl;
@property ( nonatomic ) NSString* site;

@property ( nonatomic ) NSString* username;
@property ( nonatomic ) NSString* password;
@property ( nonatomic, readonly ) BOOL selectedForBrowse;
@property ( nonatomic, readonly ) BOOL selectedForUpload;

-(id)initWithSiteUrl:(NSString*)siteUrl
                site:(NSString*)site
uploadFolderPathInsideMediaLibrary:(NSString*)uploadFolderPathInsideMediaLibrary
            username:(NSString*)username
            password:(NSString*)password
   selectedForBrowse:(BOOL)selectedForBrowse
   selectedForUpload:(BOOL)selectedForUpload;

-(NSString*)getFolderPathForUpload;

+(instancetype)emptySite;
+(NSString*)siteDefaultValue;
+(NSString*)mediaLibraryDefaultPath;
+(NSString*)mediaLibraryDefaultNameWithSlash:(BOOL)withSlash;

-(NSString*)uploadFolderPathInsideMediaLibrary;
-(void)setUploadFolderPathInsideMediaLibrary:(NSString*)uploadFolderPathInsideMediaLibrary;

@end
