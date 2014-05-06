#import <Foundation/Foundation.h>


@protocol MUMigrationStrategy;


@interface MUMigrationStrategyFactory : NSObject

+(id<MUMigrationStrategy>)removeOldDataStrategy;

@end
