#import "sc_SitesManager.h"
#import "sc_Site+Private.h"

@implementation sc_SitesManager
{
    NSMutableArray *_sitesList;
}

-(instancetype)init
{
    if ( self = [super init] )
    {
        [ self loadSites ];
    }
    
    return self;
}

-(NSUInteger)sitesCount
{
    return [ self->_sitesList count ];
}

-(void)addSite:(sc_Site *)site error:( NSError** )error
{
    if ( [ self sitesCount ] == 0 )
    {
        site.selectedForUpload = YES;
    }
    else
    {
        site.selectedForUpload = NO;
    }
    
    if ( [ self isSameSiteExist: site ] )
    {
        NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"SITE_DUPLICATE", nil) };
        *error = [[ NSError alloc ] initWithDomain: @"MU"
                                              code: 1
                                          userInfo: errorInfo ];
        return;
    }
    
    [ self->_sitesList addObject: site ];
    BOOL sitesWasSaved = [ self saveSites ];
    
    if ( !sitesWasSaved )
    {
        NSDictionary *errorInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"SITE_SAVE_ERROR", nil) };
        *error = [[ NSError alloc ] initWithDomain: @"MU"
                                              code: 1
                                          userInfo: errorInfo ];
        return;
    }
}

-(BOOL)isSameSiteExist:(sc_Site*)site
{
    if ( [ self sameSitesCount: site ] == 0)
    {
        return NO;
    }
    
    return YES;
}

-(NSUInteger)sameSitesCount:(sc_Site*)site
{
    NSUInteger result = 0;
    
    for ( sc_Site *elem in self->_sitesList )
    {
        if ( [ elem isEqual: site ] )
        {
            ++result;
        }
    }
    
    return result;
}

-(void)removeSite:(sc_Site *)site
{
    [ self->_sitesList removeObject: site ];
    [ self saveSites ];
}

-(void)removeSiteAtIndex:(NSUInteger)index
{
    [ self->_sitesList removeObjectAtIndex: index ];
    [ self saveSites ];
}

-(NSUInteger)indexOfSite:(sc_Site *)site
{
    return [ self->_sitesList indexOfObject: site ];
}

-(sc_Site *)siteAtIndex:(NSUInteger)index
{
    if ( index < [ self->_sitesList count ] )
    {
        return self->_sitesList[index];
    }
    
    return nil;
}

-(BOOL)saveSites
{
    NSString *appFile = [ self getSitesFilePath ];
    return [ NSKeyedArchiver archiveRootObject: self->_sitesList
                                        toFile: appFile ];
}

-(void)loadSites
{
    NSString *appFile = [ self getSitesFilePath ];
    
    self->_sitesList = [ NSKeyedUnarchiver unarchiveObjectWithFile: appFile ];
    if ( !self->_sitesList )
    {
        self->_sitesList = [ [ NSMutableArray alloc ] init ];
    }
}

-(NSString *)getSitesFilePath
{
    return [self getFile:@"SCSitesStorage.dat"];
}

- (NSString *)getFile:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *documentsDirectory = [ paths objectAtIndex: 0 ];
    NSString *appFile = [ documentsDirectory stringByAppendingPathComponent: fileName ];
    return appFile;
}

-(BOOL)atLeastOneSiteExists
{
    return [ self sitesCount ] > 0;
}

#pragma mark additional functions

-(sc_Site *)siteForBrowse
{
    NSAssert([ self sitesCount ] > 0, @"at least one site must exists");
    
    for ( NSInteger i = 0; i < [ self sitesCount ]; ++i )
    {
        sc_Site *site = [ self siteAtIndex: i ];
        if (site.selectedForBrowse)
        {
            return site;
        }
    }
    
    return [ self siteAtIndex: 0 ];
}

-(sc_Site *)siteForUpload
{
    for ( sc_Site *site in self->_sitesList )
    {
        if ( site.selectedForUpload)
        {
            return site;
        }
    }
    
    if ( [ self sitesCount ] > 0 )
    {
        sc_Site *site = [ self siteAtIndex: 0 ];
        site.selectedForUpload = YES;
        return site;
    }
    
    NSLog(@"No sites");
    return nil;
}

-(void)setSiteForBrowse:(sc_Site *)siteForBrowse
{
    for ( sc_Site *site in self->_sitesList )
    {
        if ( [ site isEqual: siteForBrowse ] )
        {
            site.selectedForBrowse = YES;
        }
        else
        {
            site.selectedForBrowse = NO;
        }
    }
    
    [ self saveSites ];
}

-(void)setSiteForUpload:(sc_Site *)siteForUpload
{
    for ( sc_Site *site in self->_sitesList )
    {
        if ( [ site isEqual: siteForUpload ] )
        {
            site.selectedForUpload = YES;
        }
        else
        {
            site.selectedForUpload = NO;
        }
    }
    
    [ self saveSites ];
}

@end
