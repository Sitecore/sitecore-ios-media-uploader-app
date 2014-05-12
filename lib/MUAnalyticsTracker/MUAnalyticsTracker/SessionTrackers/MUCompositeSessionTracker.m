#import "MUCompositeSessionTracker.h"


@implementation MUCompositeSessionTracker
{
    NSArray* _primitiveTrackers;
}

-(instancetype)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithTrackers:(NSArray*)primitiveTrackers
{
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }
    
    self->_primitiveTrackers = primitiveTrackers;
    
    return self;
}

-(void)appMigrationFailedWithError:( NSError* )error
{
    for ( id<MUSessionTracker> tracker in self->_primitiveTrackers )
    {
        [ tracker appMigrationFailedWithError: error ];
    }
}

-(void)didLoginWithSite:(id<MUTrackable> )site
{
    for ( id<MUSessionTracker> tracker in self->_primitiveTrackers )
    {
        [ tracker didLoginWithSite: site ];
    }
}


-(void)didLoginFailedForSite:(id<MUTrackable> )site
                   withError:(NSError*)error
{
    for ( id<MUSessionTracker> tracker in self->_primitiveTrackers )
    {
        [ tracker didLoginFailedForSite: site
                              withError: error ];
    }
}


-(void)didLogoutFromSite:(id<MUTrackable> )site
{
    for ( id<MUSessionTracker> tracker in self->_primitiveTrackers )
    {
        [ tracker didLogoutFromSite: site ];
    }
}

@end
