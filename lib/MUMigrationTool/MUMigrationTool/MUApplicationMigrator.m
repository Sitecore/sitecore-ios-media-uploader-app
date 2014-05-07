#import "MUApplicationMigrator.h"

#import "MUVersionDetector.h"
#import "MUMigrationStrategyFactory.h"

@implementation MUApplicationMigrator
{
    NSFileManager* _fileManager;
    NSString     * _rootDir    ;
}

-(instancetype)initWithFileManager:( NSFileManager* )fileManager
                rootCacheDirectory:( NSString* )rootDir __attribute__((nonnull))
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


-(BOOL)migrateUploaderAppWithError:( out NSError** )errorPtr __attribute__((nonnull))
{
    NSParameterAssert( NULL != errorPtr );
    
    NSFileManager* fm = self->_fileManager;
    NSString* documentsDirectory = self->_rootDir;
    
    MUVersionDetector* versionDetector = [ [ MUVersionDetector alloc ] initWithFileManager: fm
                                                                        rootCacheDirectory: documentsDirectory ];
    
    MUApplicationVersion version = [ versionDetector applicationVersionBeforeCurrentLaunch ];
    BOOL isUnknownVersion = ( MUVUnknown == version );
    BOOL isLatestVersion  = ( MUVLatestRelease == version );
    
    BOOL shouldPerformMigration = !( isUnknownVersion || isLatestVersion );
    if ( !shouldPerformMigration )
    {
        return YES;
    }
    
    
    MUMigrationStrategyFactory* factory =
    [ [ MUMigrationStrategyFactory alloc ] initWithFileManager: self->_fileManager
                                            rootCacheDirectory: self->_rootDir ];
    
    id<MUMigrationStrategy> migrator = [ factory removeOldDataStrategy ];

    BOOL result = [ migrator migrateMediaUploaderAppFromVersion: version
                                                      toVersion: MUVLatestRelease
                                                          error: errorPtr ];
    return result;
}

@end
