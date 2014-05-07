#import <Foundation/Foundation.h>

@interface MUApplicationMigrator : NSObject

+(BOOL)migrateUploaderAppWithError:( out NSError** )errorPtr __attribute__((nonnull));

@end
