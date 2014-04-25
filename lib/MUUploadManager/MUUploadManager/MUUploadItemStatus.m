#import "MUUploadItemStatus.h"

@implementation MUUploadItemStatus

-(NSString*)description
{
    if ( self.statusId == UPLOAD_ERROR )
        return self->_description;
    
    return nil;
}

-(NSString*)localizedDescription
{
    return NSLocalizedString(self.description, nil);
}

-(void)encodeWithCoder:(NSCoder*)encoder
{
    [ encoder encodeObject:  _description forKey: @"description" ];
    [ encoder encodeInteger: _statusId    forKey: @"statusId"    ];
}

-(instancetype)initWithCoder:(NSCoder*)decoder
{
    self = [ super init ];
    if ( self )
    {
        self.description = [ decoder decodeObjectForKey:  @"description" ];
        self.statusId    = [ decoder decodeIntegerForKey: @"statusId"    ];
    }
    
    return self;
}

@end
