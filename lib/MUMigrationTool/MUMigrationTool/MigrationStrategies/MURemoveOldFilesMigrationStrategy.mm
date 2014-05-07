#import "MURemoveOldFilesMigrationStrategy.h"

@implementation MURemoveOldFilesMigrationStrategy
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

-(BOOL)migrateMediaUploaderAppFromVersion:( MUApplicationVersion )__unused fromVersion
                                toVersion:( MUApplicationVersion )__unused toVersion
                                    error:( out NSError** )errorPtr __attribute__((nonnull))
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
        NSString* fullPathOfSubdir = [ self->_rootDir stringByAppendingPathComponent: subdir ];
        
        BOOL removeResult = [ self->_fileManager removeItemAtPath: fullPathOfSubdir
                                                            error: errorPtr ];
        if ( !removeResult )
        {
            return NO;
        }
    }
    
    return YES;
}

@end
