#import "MUVersionDetector.h"

@implementation MUVersionDetector

-(instancetype)init __attribute__((noreturn))
{
    throw std::runtime_error( "unsupported initializer" );

    return [ self initWithFileManager: nil
                   rootCacheDirectory: nil ];
}

-(instancetype)initWithFileManager:( NSFileManager* )fileManager
                rootCacheDirectory:( NSString* )rootDir
{
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }
    
    return self;
}

@end
