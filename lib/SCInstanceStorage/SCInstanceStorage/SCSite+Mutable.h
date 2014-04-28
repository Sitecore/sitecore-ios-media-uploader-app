#import "SCSite.h"

@interface SCSite (Mutable)

@property ( nonatomic, readwrite ) NSString* siteProtocol;
@property ( nonatomic, readwrite ) NSString* siteUrl;
@property ( nonatomic, readwrite ) NSString* site;

@property ( nonatomic, readwrite ) NSString* username;
@property ( nonatomic, readwrite ) NSString* password;


@end
