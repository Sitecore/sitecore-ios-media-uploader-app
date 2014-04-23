#import "MUUploadItemStatus.h"

@implementation MUUploadItemStatus

-(NSString*)description
{
    if ( self.statusId == errorStatus )
        return self->_description;
    
    return nil;
}

-(NSString*)localizedDescription
{
    return NSLocalizedString(self.description, nil);
}

@end
