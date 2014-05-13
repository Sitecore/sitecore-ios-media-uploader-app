#import "SCSite+Keychain.h"

@implementation SCSite (Keychain)

-(NSString*)password
{
    NSDictionary* keychainAttributes =
    @{
        (__bridge id)kSecClass : (__bridge id)kSecClassInternetPassword
    };
    
    return nil;
}

-(void)setPassword:( NSString* )password
{
    
}

@end
