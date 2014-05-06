#import "MURemoveOldFilesMigrationStrategy.h"

@implementation MURemoveOldFilesMigrationStrategy
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

-(BOOL)migrateMediaUploaderAppFromVersion:( MUApplicationVersion )__unused fromVersion
                                toVersion:( MUApplicationVersion )__unused toVersion
                                    error:( NSError** )errorPtr __attribute__((nonnull))
{
    NSParameterAssert( NULL != errorPtr );

    NSArray* cacheDirectoryContents = [ self->_fileManager contentsOfDirectoryAtPath: self->_rootDir
                                                                               error: errorPtr ];
    if ( nil == cacheDirectoryContents )
    {
        return NO;
    }
    
    
    for ( NSString* subdir in cacheDirectoryContents )
    {
        BOOL removeResult = [ self->_fileManager removeItemAtPath: subdir
                                                            error: errorPtr ];
        if ( !removeResult )
        {
            return NO;
        }
    }
    
    return YES;
}

@end
