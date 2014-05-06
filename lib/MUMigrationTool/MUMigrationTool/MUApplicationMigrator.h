#import <Foundation/Foundation.h>

@interface MUApplicationMigrator : NSObject

+(BOOL)migrateUploaderAppWithError:( NSError** )errorPtr __attribute__((nonnull));

@end
