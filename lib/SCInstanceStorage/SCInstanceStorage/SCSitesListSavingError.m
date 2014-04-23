#import "SCSitesListSavingError.h"

@implementation SCSitesListSavingError

- (instancetype)init
{
    NSDictionary* errorInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"SITE_SAVE_ERROR", nil) };
    self = [ super initWithDomain: @"MU"
                             code: 1
                         userInfo: errorInfo ];
    
    if ( self != nil )
    {
    
    }
    
    return self;
}

- (instancetype)initWithDescription:(NSString *)description
                             domain:(NSString *)domain
                               code:(NSInteger)code
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
