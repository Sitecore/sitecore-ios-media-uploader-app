#import "SCSite.h"

@interface SCSite (Mutable)

@property ( nonatomic, readwrite ) NSString* siteId;
@property ( nonatomic, readwrite ) NSString* siteProtocol;
@property ( nonatomic, readwrite ) NSString* siteUrl;
@property ( nonatomic, readwrite ) NSString* site;
@property ( nonatomic, readwrite ) NSString* uploadFolderPathInsideMediaLibrary;

@property ( nonatomic, readwrite ) NSString* username;
@property ( nonatomic, readwrite ) NSString* password;

@property ( nonatomic, readwrite ) BOOL selectedForBrowse;
@property ( nonatomic, readwrite ) BOOL selectedForUpload;


@end
