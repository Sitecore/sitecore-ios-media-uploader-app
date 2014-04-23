#import "SCSite.h"

@interface SCSite (Private)

@property ( nonatomic ) BOOL selectedForBrowse;
@property ( nonatomic ) BOOL selectedForUpload;
@property ( nonatomic ) NSString* siteId;

-(void)generateId;

@end
