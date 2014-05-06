#import "MUMigrationStrategyFactory.h"

#import "MURemoveOldFilesMigrationStrategy.h"


@implementation MUMigrationStrategyFactory
{
    NSFileManager* _fileManager;
    NSString     * _rootDir    ;
}

-(instancetype)init __attribute__((noreturn))
{
    throw std::runtime_error( "unsupported initializer" );
    
    // unreachable code
    // Stays here to make compiler happy
    return [ self initWithFileManager: [ NSFileManager defaultManager ]
                   rootCacheDirectory: @"" ];
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

-(id<MUMigrationStrategy>)removeOldDataStrategy
{
    return [ [ MURemoveOldFilesMigrationStrategy alloc ] init ];
}

@end
