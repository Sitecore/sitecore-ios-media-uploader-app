#import "SCSite+Private.h"

@implementation SCSite (Private)

@dynamic selectedForBrowse;
@dynamic selectedForUpload;
@dynamic siteId;

-(void)generateId
{
    self.siteId = [ [ self class ] getUuid ];
}

+(NSString *)getUuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge NSString *)uuidStringRef;
}

@end
