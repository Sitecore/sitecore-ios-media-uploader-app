//
//  sc_GlobaldataObject.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/8/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_GlobalDataObject.h"
#import "sc_ConnectivityHelper.h"
#import "sc_AppDelegateProtocol.h"

@implementation sc_GlobalDataObject

+(NSString*)applicationDocumentsDir
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString* documentsDirectory = [ paths objectAtIndex: 0 ];
    
    return documentsDirectory;
}

+(NSString*)cacheFilesDirectory
{
    NSString* documents = [ self applicationDocumentsDir ];
    
    NSString* subDir = [ MUApplicationVersionHelper subFolderForLatestVersion ];
    NSString* result = [ documents stringByAppendingPathComponent: subDir ];
    
    return result;
}

+(sc_GlobalDataObject*)getAppDataObject
{
    id<sc_AppDelegateProtocol> delegate = (id<sc_AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
    sc_GlobalDataObject* result         = (sc_GlobalDataObject*)delegate.appDataObject;
    
    return result;
}

-(instancetype)init
{
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }
    
    
    NSString* rootDir = [ [ self class ] cacheFilesDirectory ];
    {
        NSFileManager* fm = [ NSFileManager defaultManager ];
        
        
        NSError* error = nil;
        BOOL isCacheDirCreated = NO;
        isCacheDirCreated = [ fm createDirectoryAtPath: rootDir
                           withIntermediateDirectories: YES
                                            attributes: nil
                                                 error: &error ];
        if ( !isCacheDirCreated )
        {
            NSLog(@"[FATAL] Cached directory not created");
            return nil;
        }
    }
    
    self->_sitesManager       = [ [ SCSitesManager          alloc ] initWithCacheFilesRootDirectory: rootDir ];
    self->_uploadItemsManager = [ [ MUItemsForUploadManager alloc ] initWithCacheFilesRootDirectory: rootDir ];

    return self;
}


-(BOOL)isOnline
{
    return [sc_ConnectivityHelper connectedToInternet];
}

@end
