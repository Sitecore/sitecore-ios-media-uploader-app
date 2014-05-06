#import "MUApplicationMigrator.h"

#import "MUVersionDetector.h"
#import "MUMigrationStrategyFactory.h"

@implementation MUApplicationMigrator

+(BOOL)migrateUploaderAppWithError:( NSError** )errorPtr __attribute__((nonnull))
{
    NSParameterAssert( NULL != errorPtr );
    
    NSFileManager* fm = [ NSFileManager defaultManager ];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString* documentsDirectory = [ paths objectAtIndex: 0 ];
    
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
    
    
    id<MUMigrationStrategy> migrator = [ MUMigrationStrategyFactory removeOldDataStrategy ];

    BOOL result = [ migrator migrateMediaUploaderAppFromVersion: version
                                                      toVersion: MUVLatestRelease
                                                          error: errorPtr ];
    return result;
}

@end
