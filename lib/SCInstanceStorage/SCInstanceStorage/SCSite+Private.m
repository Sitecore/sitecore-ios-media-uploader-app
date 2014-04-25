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
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    NSString*  uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault,
                                                                            newUniqueId);
    CFRelease(newUniqueId);
    
    return uuidString;
}

@end
