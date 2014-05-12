#import "MUMigrationStrategyFactory.h"

#import "MURemoveOldFilesMigrationStrategy.h"


@implementation MUMigrationStrategyFactory
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


-(id<MUMigrationStrategy>)removeOldDataStrategy
{
    NSFileManager* fm = self->_fileManager;
    NSString* documentsDirectory = self->_rootDir;
    
    return [ [ MURemoveOldFilesMigrationStrategy alloc ] initWithFileManager: fm
                                                          rootCacheDirectory: documentsDirectory ];
}

@end
