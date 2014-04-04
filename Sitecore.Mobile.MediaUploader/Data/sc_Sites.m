//
//  sc_Sites.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/17/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_Sites.h"

@implementation sc_Sites
@synthesize sites = _sites;


-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init])
    {
        _sites = [aDecoder decodeObjectForKey:@"Sites20"];
        
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:_sites forKey:@"Sites20"];
}

@end
