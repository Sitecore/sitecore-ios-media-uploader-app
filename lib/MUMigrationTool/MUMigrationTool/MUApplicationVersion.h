#ifndef MUMigrationTool_MUApplicationVersion_h
#define MUMigrationTool_MUApplicationVersion_h

#import <Foundation/Foundation.h>

typedef NS_ENUM( NSInteger, MUApplicationVersion )
{
    MUVUnknown = 0,
    
    MUVVersion_1_0 = 10000, // v1.0
    MUVVersion_1_1 = 10100, // v1.1
    
    
    MUVFirstRelease  = MUVVersion_1_0,
    MUVLatestRelease = MUVVersion_1_1
};

#endif
