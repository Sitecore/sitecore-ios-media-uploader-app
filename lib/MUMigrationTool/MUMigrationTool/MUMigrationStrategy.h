#import <Foundation/Foundation.h>
#import <MUMigrationTool/MUApplicationVersion.h>

@protocol MUMigrationStrategy <NSObject>

-(BOOL)migrateMediaUploaderAppFromVersion:( MUApplicationVersion )fromVersion
                                toVersion:( MUApplicationVersion )toVersion
                                    error:( NSError** )errorPtr __attribute__((nonnull));

@end
