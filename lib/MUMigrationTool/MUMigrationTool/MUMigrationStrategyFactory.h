#import <Foundation/Foundation.h>


@protocol MUMigrationStrategy;


@interface MUMigrationStrategyFactory : NSObject


/**
 Unsupported initializer.
 
 @return Never happens.
 */
+(instancetype)new __attribute__((noreturn, unavailable("Unsupported Initializer")));


/**
 Unsupported initializer.
 
 @return Never happens.
 */
-(instancetype)init __attribute__((noreturn, unavailable("Unsupported Initializer")));

-(instancetype)initWithFileManager:( NSFileManager* )fileManager
                rootCacheDirectory:( NSString* )rootDir __attribute__((nonnull));

-(id<MUMigrationStrategy>)removeOldDataStrategy;

@end
