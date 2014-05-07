#import "SCSitesManager.h"
#import "SCSite+Private.h"
#import "SCSitesListSavingError.h"

#import "SCSite+Mutable.h"

@implementation SCSitesManager
{
    NSMutableArray* _sitesList;
    NSString      * _rootDir  ;
}

-(instancetype)initWithCacheFilesRootDirectory:( NSString* )rootDir __attribute__((nonnull))
{
    NSParameterAssert( nil != rootDir );
    
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }
    
    
    // @adk : order matters
    self->_rootDir = rootDir;
    [ self loadSites ];
    
    return self;
}

-(NSArray*)sitesList __attribute__((const));
{
    return [ NSArray arrayWithArray: self->_sitesList ];
}

-(NSUInteger)sitesCount __attribute__((const));
{
    return [ self->_sitesList count ];
}

-(BOOL)addSite:(SCSite*)site error:(NSError**)error __attribute__((nonnull))
{
    NSParameterAssert( nil  != site  );
    NSParameterAssert( NULL != error );
    
    if ( [ self sitesCount ] == 0 )
    {
        site.selectedForUpload = YES;
    }
    else
    {
        site.selectedForUpload = NO;
    }
    
    [ self->_sitesList addObject: site ];
    BOOL sitesWasSaved = [ self saveSites ];
    
    if ( !sitesWasSaved )
    {
        *error = [ SCSitesListSavingError new ];
        return NO;
    }
    
    return YES;
}

-(void)makeSiteIdUnique:(SCSite *)site __attribute__((nonnull))
{
    NSParameterAssert( nil != site );
    
    SCPredicateBlock siteIsEqualSearchPredicate = ^BOOL( SCSite* elem )
    {
        return [ elem.siteId isEqual: site.siteId ];
    };
    
    NSUInteger result = [ self->_sitesList count: siteIsEqualSearchPredicate ];;
    
    while (result > 0)
    {
        [ site generateId ];
        result = [ self->_sitesList count: siteIsEqualSearchPredicate ];
    }
}

-(BOOL)isSameSiteExist:(SCSite*)site __attribute__((nonnull))
{
    NSParameterAssert( nil != site );
    
    if ( 0 == [ self sameSitesCount: site ] )
    {
        return NO;
    }
    
    return YES;
}

-(NSUInteger)sameSitesCount:(SCSite*)site __attribute__((nonnull))
{
    NSParameterAssert( nil  != site  );
    
    SCPredicateBlock siteIsEqualSearchPredicate = ^BOOL( SCSite* elem )
    {
        return [ elem isEqual: site ];
    };
    NSUInteger result = [ self->_sitesList count: siteIsEqualSearchPredicate ];
    
    return result;
}

-(BOOL)removeSite:(SCSite*)site error:(NSError**)error __attribute__((nonnull))
{
    NSParameterAssert( nil  != site  );
    NSParameterAssert( NULL != error );

    
    SCSite* siteToRemove = [ self siteBySiteId:site.siteId ];
    
    if( siteToRemove != nil )
    {
        [ self->_sitesList removeObject: siteToRemove ];
        return [ self saveSites ];
    }
    
    return NO;
}

-(BOOL)removeSiteAtIndex:(NSUInteger)index error:(NSError**)error __attribute__((nonnull))
{
    NSParameterAssert( NULL != error );

    
    [ self->_sitesList removeObjectAtIndex: index ];
    return [ self saveSites ];
}

-(NSUInteger)indexOfSite:(SCSite*)site __attribute__((nonnull))
{
    NSParameterAssert( nil  != site  );
    
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

-(SCSite*)siteBySiteId:(NSString*)siteId __attribute__((nonnull))
{
    NSParameterAssert( nil  != siteId );
    
    SCPredicateBlock siteIsEqualSearchPredicate = ^BOOL( SCSite* elem )
    {
        return [ elem.siteId isEqualToString:siteId ];
    };
    SCSite* result = [ self->_sitesList firstMatch: siteIsEqualSearchPredicate ];
    
    return result;
}

-(BOOL)saveSiteChanges:(SCSite*)site error:(NSError**)error __attribute__((nonnull))
{
    NSParameterAssert( nil  != site  );
    NSParameterAssert( NULL != error );

    
    SCSite* siteForEdit = [ self siteBySiteId: site.siteId ];
    
    siteForEdit.siteProtocol                        = site.siteProtocol;
    siteForEdit.siteUrl                             = site.siteUrl;
    siteForEdit.site                                = site.site;
    siteForEdit.uploadFolderPathInsideMediaLibrary  = site.uploadFolderPathInsideMediaLibrary;
    siteForEdit.username                            = site.username;
    siteForEdit.password                            = site.password;
    siteForEdit.selectedForBrowse                   = site.selectedForBrowse;
    siteForEdit.selectedForUpload                   = site.selectedForUpload;

    return [ self saveSites ];
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

-(NSString*)getFile:(NSString*)fileName __attribute__((nonnull))
{
    NSParameterAssert( nil  != fileName );

    NSString* documentsDirectory = self->_rootDir;
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

-(BOOL)setSiteForBrowse:(SCSite*)siteForBrowse error:(NSError**)error __attribute__((nonnull))
{
    NSParameterAssert( nil  != siteForBrowse  );
    NSParameterAssert( NULL != error          );

    
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
    
    return [ self saveSites ];
}

-(BOOL)setSiteForUpload:(SCSite*)siteForUpload error:(NSError**)error __attribute__((nonnull))
{
    NSParameterAssert( nil  != siteForUpload );
    NSParameterAssert( NULL != error         );

    
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
    
    return [ self saveSites ];
}

@end
