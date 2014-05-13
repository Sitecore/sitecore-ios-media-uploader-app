#import "MUUploadItemStatus.h"

@interface MUUploadItemStatus()

@property (nonatomic, readwrite) MUUploadItemStatusType statusId;
@property (nonatomic, readwrite) NSString* statusDescription;

@end


@implementation MUUploadItemStatus

-(instancetype)initWithStatusId:( MUUploadItemStatusType )statusId
{
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }
    
    self.statusId = statusId;
    
    return self;
}

-(instancetype)initWithErrorDescription:(NSString*)statusDescription
{
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }
    
    self.statusId = UPLOAD_ERROR;
    self->_statusDescription = statusDescription;
    
    return self;
}

-(NSString*)description
{
    if ( self.statusId == UPLOAD_ERROR )
    {
        return self->_statusDescription;
    }
    
    return [ super description ];
}

-(void)encodeWithCoder:(NSCoder*)encoder
{
    [ encoder encodeObject:  _statusDescription forKey: @"statusDescription" ];
    [ encoder encodeInteger: _statusId          forKey: @"statusId"    ];
}

-(instancetype)initWithCoder:(NSCoder*)decoder
{
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }

    self.statusDescription  = [ decoder decodeObjectForKey:  @"statusDescription" ];
    self.statusId           = [ decoder decodeIntegerForKey: @"statusId"    ];

    
    return self;
}

@end
