#import <MUMigrationTool/MUApplicationVersion.h>
#import <Foundation/Foundation.h>

@interface MUApplicationVersionHelper : NSObject

+(NSString*)subFolderForLatestVersion;

+(NSString*)subFolderForVersion:( MUApplicationVersion )version;
+(MUApplicationVersion)versionBySubfolder:( NSString* )subFolder;

+(NSArray*)subfoldersForKnownVersions;

@end
