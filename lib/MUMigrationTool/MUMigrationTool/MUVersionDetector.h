#import <Foundation/Foundation.h>

#import <MUMigrationTool/MUApplicationVersion.h>


@interface MUVersionDetector : NSObject

/**
 Unsupported initializer.
 
 @return Never happens.
 */
-(instancetype)init __attribute__((noreturn, unavailable("Unsupported initializer")));

/**
 Unsupported initializer.
 
 @return Never happens.
 */
+(instancetype)new __attribute__((noreturn, unavailable("Unsupported initializer")));



/**
 A designated initializer.
 
 @param fileManager A file manager for files lookup.
 @param rootDir A directory to scan for cache files. Typically, it is "Documents".
 
 @return A properly initialized object.
 */
-(instancetype)initWithFileManager:( NSFileManager* )fileManager
                rootCacheDirectory:( NSString* )rootDir __attribute__((nonnull, objc_designated_initializer));


/**
 Detects application version
 
 @return Version based on the cache files. If no cache files are found, the version is assumed to be the latest one and no migration is required.
 */
-(MUApplicationVersion)applicationVersionBeforeCurrentLaunch;


@end
