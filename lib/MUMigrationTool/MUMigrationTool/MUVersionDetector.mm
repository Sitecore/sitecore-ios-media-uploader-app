#import "MUVersionDetector.h"

#define CPP_STRING_LINKER_ERRORS 0

#if !CPP_STRING_LINKER_ERRORS
typedef std::map<std::string, MUApplicationVersion> MUCacheFolderForVersionMap;
typedef MUCacheFolderForVersionMap::const_iterator MUCacheFolderForVersionMap_ci;
#endif


@implementation MUVersionDetector
{
    NSFileManager* _fileManager;
    NSString     * _rootDir    ;
}


#if CPP_STRING_LINKER_ERRORS
+(NSDictionary*)relativeFolderForVersions
{
    static NSDictionary* result;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^void()
    {
        result =
        @{
            @"v1.1" : @(MUVVersion_1_1)
        };
    });
    
    return result;
}

#else
+(const MUCacheFolderForVersionMap&)relativeFolderForVersions
{
    static MUCacheFolderForVersionMap result;

    MUCacheFolderForVersionMap* resultPtr = &result;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^void()
    {
        MUCacheFolderForVersionMap& resultRef = (*resultPtr);
        resultRef["v1.1"] = MUVVersion_1_1;
    });

    return result;
}
#endif

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
    NSArray* relativeDirectories =
    @[
         @"v1.1"
    ];
    
    NSFileManager* fm = self->_fileManager;
    
    SCPredicateBlock siteStorageFileExistsBlock = ^BOOL( NSString* relativeDir )
    {
        NSString* cacheRootFullPath = [ self->_rootDir stringByAppendingPathComponent: relativeDir ];
        NSString* storageFileFullPath = [ cacheRootFullPath stringByAppendingPathComponent: CONNECTION_INFO_LIST_FILENAME ];

        return [ fm fileExistsAtPath: storageFileFullPath ];
    };
    
    NSString* relativeDir = [ relativeDirectories firstMatch: siteStorageFileExistsBlock ];
    if ( nil == relativeDir )
    {
        return MUVUnknown;
    }

#if CPP_STRING_LINKER_ERRORS
    NSDictionary* folderToEnumMap = [ [ self class ] relativeFolderForVersions ];
    NSNumber* boxedResult = folderToEnumMap[relativeDir];
    
    NSInteger rawResult = [ boxedResult integerValue ];
    MUApplicationVersion result = static_cast<MUApplicationVersion>( rawResult );
#else
    std::string cppRelativeDir = [ relativeDir cStringUsingEncoding: NSUTF8StringEncoding ];
    const MUCacheFolderForVersionMap& folderToEnumMap = [ [ self class ] relativeFolderForVersions ];
    

    MUCacheFolderForVersionMap_ci resultIt = folderToEnumMap.find(cppRelativeDir);
    MUApplicationVersion result = resultIt->second;
#endif
    
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
