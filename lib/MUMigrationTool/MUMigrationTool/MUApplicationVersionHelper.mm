#import "MUApplicationVersionHelper.h"

typedef std::map<std::string         , MUApplicationVersion> MUCacheFolderToVersionMap;
typedef std::map<MUApplicationVersion, NSString*           > MUVersionToCacheFolderMap;


@implementation MUApplicationVersionHelper


+(const MUCacheFolderToVersionMap&)relativeFolderToVersions
{
    static MUCacheFolderToVersionMap result;
    
    MUCacheFolderToVersionMap* resultPtr = &result;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^void()
    {
      MUCacheFolderToVersionMap& resultRef = (*resultPtr);
      resultRef["v1.1"] = MUVVersion_1_1;
    });
    
    return result;
}


+(const MUVersionToCacheFolderMap&)versionToRelativeFolders
{
    static MUVersionToCacheFolderMap result;
    MUVersionToCacheFolderMap* resultPtr = &result;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^void()
    {
        MUVersionToCacheFolderMap& resultRef = (*resultPtr);

        resultRef[MUVUnknown    ] = @""    ;
        resultRef[MUVVersion_1_0] = @""    ;
        resultRef[MUVVersion_1_1] = @"v1.1";
    });
    
    return result;
}

#pragma mark -
#pragma mark Public
+(NSString*)subFolderForLatestVersion
{
    return [ self subFolderForVersion: MUVLatestRelease ];
}

+(NSString*)subFolderForVersion:( MUApplicationVersion )version
{
    auto mapper = [ self versionToRelativeFolders ];
    NSString* result = mapper[version];
    
    return result;
}


+(MUApplicationVersion)versionBySubfolder:( NSString* )relativeDir
{
    if ( nil == relativeDir )
    {
        return MUVUnknown;
    }
    
    auto folderToVersionMap = [ self relativeFolderToVersions ];

    
    
    std::string cppRelativeDir = [ relativeDir cStringUsingEncoding: NSUTF8StringEncoding ];
    const MUCacheFolderToVersionMap& folderToEnumMap = [ [ self class ] relativeFolderToVersions ];
    
    
    auto resultIt = folderToEnumMap.find(cppRelativeDir);
    if ( folderToEnumMap.end() == resultIt )
    {
        return MUVUnknown;
    }
    MUApplicationVersion result = resultIt->second;

    return result;
}

+(NSArray*)subfoldersForKnownVersions
{
    NSArray* relativeDirectories =
    @[
        @"v1.1"
    ];

    return relativeDirectories;
}

@end
