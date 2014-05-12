#import "MUUploadItemStatus.h"

@implementation MUUploadItemStatus

-(NSString*)description
{
    if ( self.statusId == UPLOAD_ERROR )
    {
        return self->_statusDescription;
    }
    
    return nil;
}

-(void)encodeWithCoder:(NSCoder*)encoder
{
    [ encoder encodeObject:  _statusDescription forKey: @"statusDescription" ];
    [ encoder encodeInteger: _statusId          forKey: @"statusId"    ];
}

-(instancetype)initWithCoder:(NSCoder*)decoder
{
    self = [ super init ];
    if ( nil != self )
    {
        self.statusDescription  = [ decoder decodeObjectForKey:  @"statusDescription" ];
        self.statusId           = [ decoder decodeIntegerForKey: @"statusId"    ];
    }
    
    return self;
}

@end
