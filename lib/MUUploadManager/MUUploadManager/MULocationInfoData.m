#import "MULocationInfoData.h"

@implementation MULocationInfoData

-(void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:  _latitude            forKey: @"latitude"            ];
    [encoder encodeObject:  _longitude           forKey: @"longitude"           ];
    [encoder encodeObject:  _locationDescription forKey: @"locationDescription" ];
    [encoder encodeObject:  _countryCode         forKey: @"countryCode"         ];
    [encoder encodeObject:  _cityCode            forKey: @"cityCode"            ];
}

-(instancetype)initWithCoder:(NSCoder*)decoder
{
    self = [super init];
    if (self)
    {
        self.latitude            = [decoder decodeObjectForKey:  @"latitude"            ];
        self.longitude           = [decoder decodeObjectForKey:  @"longitude"           ];
        self.locationDescription = [decoder decodeObjectForKey:  @"locationDescription" ];
        self.countryCode         = [decoder decodeObjectForKey:  @"countryCode"         ];
        self.cityCode            = [decoder decodeObjectForKey:  @"cityCode"            ];
    }
    
    return self;
}

@end
