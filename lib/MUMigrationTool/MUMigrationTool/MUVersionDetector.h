#import <Foundation/Foundation.h>

@interface MUVersionDetector : NSObject

/**
 Unsupported initializer.
 
 @return Never happens. Throws ```std::runtime_error()```
 */
-(instancetype)init __attribute__((noreturn));

/**
 A designated initializer.
 
 @param fileManager A file manager for files lookup. 
 @param rootDir A directory to scan for cache files. Typically, it is "Documents".
 
 @return A properly initialized object.
 */
-(instancetype)initWithFileManager:( NSFileManager* )fileManager
                rootCacheDirectory:( NSString* )rootDir __attribute__((objc_designated_initializer));

@end
