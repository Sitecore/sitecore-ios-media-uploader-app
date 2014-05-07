#import "MUVersionDetector.h"
#import "MUApplicationVersionHelper.h"


@implementation MUVersionDetector
{
    NSFileManager* _fileManager;
    NSString     * _rootDir    ;
}



-(instancetype)initWithFileManager:( NSFileManager* )fileManager
                rootCacheDirectory:( NSString* )rootDir
{
    NSParameterAssert( nil != fileManager );
    NSParameterAssert( nil != rootDir     );
    
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }
    
    self->_fileManager = fileManager;
    self->_rootDir     = rootDir    ;
    
    return self;
}



-(BOOL)isFirstReleaseCacheFilesDetected
{
    static NSString* const CONNECTION_INFO_LIST_FILENAME = @"sites.txt";
    NSString* fullNameOfInfoListFile = [ self->_rootDir stringByAppendingPathComponent: CONNECTION_INFO_LIST_FILENAME ];
    
    BOOL result = [ self->_fileManager fileExistsAtPath: fullNameOfInfoListFile ];
    
    return result;
}

-(MUApplicationVersion)versionedReleaseNumber
{
    static NSString* const CONNECTION_INFO_LIST_FILENAME = @"SCSitesStorage.dat";
    NSArray* relativeDirectories = [ MUApplicationVersionHelper subfoldersForKnownVersions ];
    
    NSFileManager* fm = self->_fileManager;
    
    SCPredicateBlock siteStorageFileExistsBlock = ^BOOL( NSString* relativeDir )
    {
        NSString* cacheRootFullPath = [ self->_rootDir stringByAppendingPathComponent: relativeDir ];
        NSString* storageFileFullPath = [ cacheRootFullPath stringByAppendingPathComponent: CONNECTION_INFO_LIST_FILENAME ];

        return [ fm fileExistsAtPath: storageFileFullPath ];
    };
    
    NSString* relativeDir = [ relativeDirectories firstMatch: siteStorageFileExistsBlock ];
    MUApplicationVersion result = [ MUApplicationVersionHelper versionBySubfolder: relativeDir ];
    
    return result;
}

-(MUApplicationVersion)applicationVersionBeforeCurrentLaunch
{
    if ( [ self isFirstReleaseCacheFilesDetected ] )
    {
        return MUVFirstRelease;
    }
    
    return [ self versionedReleaseNumber ];
}

@end
