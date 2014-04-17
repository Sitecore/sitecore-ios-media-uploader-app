#import "SCSitesManager.h"
#import "SCSite+Private.h"



@implementation SCSitesManager
{
    NSMutableArray* _sitesList;
}

-(instancetype)init
{
    self = [ super init ];
    if ( nil != self )
    {
        [ self loadSites ];
    }
    
    return self;
}

-(NSUInteger)sitesCount
{
    return [ self->_sitesList count ];
}

-(BOOL)addSite:(SCSite*)site error:(NSError**)error
{
    NSParameterAssert( NULL != error );
    
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
        NSDictionary* errorInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"SITE_DUPLICATE", nil) };
        *error = [[ NSError alloc ] initWithDomain: @"MU"
                                              code: 1
                                          userInfo: errorInfo ];
        return NO;
    }
    
    [ self->_sitesList addObject: site ];
    BOOL sitesWasSaved = [ self saveSites ];
    
    if ( !sitesWasSaved )
    {
        NSDictionary* errorInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"SITE_SAVE_ERROR", nil) };
        *error = [[ NSError alloc ] initWithDomain: @"MU"
                                              code: 1
                                          userInfo: errorInfo ];
        return NO;
    }
    
    return YES;
}

-(BOOL)isSameSiteExist:(SCSite*)site
{
    if ( 0 == [ self sameSitesCount: site ] )
    {
        return NO;
    }
    
    return YES;
}

-(NSUInteger)sameSitesCount:(SCSite*)site
{
    SCPredicateBlock siteIsEqualSearchPredicate = ^BOOL( SCSite* elem )
    {
        return [ elem isEqual: site ];
    };
    NSUInteger result = [ self->_sitesList count: siteIsEqualSearchPredicate ];
    
    return result;
}

-(void)removeSite:(SCSite*)site
{
    [ self->_sitesList removeObject: site ];
    [ self saveSites ];
}

-(void)removeSiteAtIndex:(NSUInteger)index
{
    [ self->_sitesList removeObjectAtIndex: index ];
    [ self saveSites ];
}

-(NSUInteger)indexOfSite:(SCSite*)site
{
    return [ self->_sitesList indexOfObject: site ];
}

-(SCSite*)siteAtIndex:(NSUInteger)index
{
    if ( index < [ self->_sitesList count ] )
    {
        return self->_sitesList[index];
    }
    
    return nil;
}

-(BOOL)saveSites
{
    NSString* appFile = [ self getSitesFilePath ];
    return [ NSKeyedArchiver archiveRootObject: self->_sitesList
                                        toFile: appFile ];
}

-(void)loadSites
{
    NSString* appFile = [ self getSitesFilePath ];
    
    self->_sitesList = [ NSKeyedUnarchiver unarchiveObjectWithFile: appFile ];
    if ( !self->_sitesList )
    {
        self->_sitesList = [ [ NSMutableArray alloc ] init ];
    }
}

-(NSString*)getSitesFilePath
{
    return [ self getFile: @"SCSitesStorage.dat" ];
}

-(NSString*)getFile:(NSString*)fileName
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString* documentsDirectory = [ paths objectAtIndex: 0 ];
    NSString* appFile = [ documentsDirectory stringByAppendingPathComponent: fileName ];
    
    return appFile;
}

-(BOOL)atLeastOneSiteExists
{
    return [ self sitesCount ] > 0;
}

#pragma mark additional functions

-(SCSite*)siteForBrowse
{
    NSParameterAssert( [ self sitesCount ] > 0 );
    // TODO : refactor
    // different requirements on sites count
    
    
    SCPredicateBlock selectedSitePredicate = ^BOOL( SCSite* site )
    {
        return site.selectedForBrowse;
    };
    
    SCSite* selectedSite = [ self->_sitesList firstMatch: selectedSitePredicate ];
    if ( nil == selectedSite )
    {
        selectedSite = [ self siteAtIndex: 0 ];
        selectedSite.selectedForBrowse = YES;
    }
    
    return selectedSite;
}

-(SCSite*)siteForUpload
{
    SCPredicateBlock selectedSitePredicate = ^BOOL( SCSite* site )
    {
        return site.selectedForUpload;
    };
    
    SCSite* foundSiteForUpload = [ self->_sitesList firstMatch: selectedSitePredicate ];
    if ( nil != foundSiteForUpload )
    {
        return foundSiteForUpload;
    }
    
    
    
    // TODO : refactor
    // different requirements on sites count
    if ( [ self sitesCount ] > 0 )
    {
        SCSite *site = [ self siteAtIndex: 0 ];
        site.selectedForUpload = YES;

        return site;
    }
    
    NSLog(@"No sites");
    return nil;
}

-(void)setSiteForBrowse:(SCSite*)siteForBrowse
{
    for ( SCSite *site in self->_sitesList )
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

-(void)setSiteForUpload:(SCSite*)siteForUpload
{
    for ( SCSite *site in self->_sitesList )
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
