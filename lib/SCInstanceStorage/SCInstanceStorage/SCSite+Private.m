#import "SCSite+Private.h"

@implementation SCSite (Private)

@dynamic selectedForBrowse;
@dynamic selectedForUpload;
@dynamic siteId;

-(void)generateId
{
    if ( self.siteId != nil )
    {
        [ self resetPasswordStorage ];
    }
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

#pragma mark password processing
#pragma mark -------------------

-(NSString*)password
{
    KeychainItemWrapper* keychain = [ self keychain ];
    
    return [ keychain objectForKey: (__bridge id)(kSecValueData) ];
}

-(void)setPassword:(NSString*)password
{
    KeychainItemWrapper* keychain = [ self keychain ];
    
    [ keychain setObject: password
                  forKey: (__bridge id)(kSecValueData) ];
}

-(KeychainItemWrapper*)keychain
{
    if ( self.siteId == nil )
    {
        [ self generateId ];
    }
    
    KeychainItemWrapper* keychain = [ [ KeychainItemWrapper alloc ] initWithIdentifier: self.siteId
                                                                           accessGroup: nil ];
    [ keychain setObject: self.siteId
                  forKey: (__bridge id)(kSecAttrService) ];
    
    [ keychain setObject: (__bridge id)(kSecAttrAccessibleWhenUnlocked)
                  forKey: (__bridge id)(kSecAttrAccessible) ];
    
    return keychain;
}

-(void)resetPasswordStorage
{
    KeychainItemWrapper* keychain = [ self keychain ];
    [ keychain resetKeychainItem ];
}

@end
