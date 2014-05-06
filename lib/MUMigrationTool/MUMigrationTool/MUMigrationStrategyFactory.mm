#import "MUMigrationStrategyFactory.h"

#import "MURemoveOldFilesMigrationStrategy.h"


@implementation MUMigrationStrategyFactory

+(id<MUMigrationStrategy>)removeOldDataStrategy
{
    NSFileManager* fm = [ NSFileManager defaultManager ];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString* documentsDirectory = [ paths objectAtIndex: 0 ];
    
    return [ [ MURemoveOldFilesMigrationStrategy alloc ] initWithFileManager: fm
                                                          rootCacheDirectory: documentsDirectory ];
}

@end
