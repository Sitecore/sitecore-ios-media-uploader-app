//
//  sc_GlobaldataObject.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/8/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_GlobalDataObject.h"
#import "sc_Media.h"
#import "sc_Constants.h"
#import "sc_ConnectivityHelper.h"
#import "sc_AppDelegateProtocol.h"

@implementation sc_GlobalDataObject

+(sc_GlobalDataObject*)getAppDataObject
{
    id<sc_AppDelegateProtocol> delegate = (id<sc_AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
    return (sc_GlobalDataObject*) delegate.appDataObject;
}

-(instancetype)init
{
    if ( self = [super init] )
    {
        self->_sitesManager = [ sc_SitesManager new ];
        [ self loadMediaUpload ];
    }
    
    return self;
}

-(void)addMediaUpload:(sc_Media*) media
{
    [_mediaUpload addObject:media];
}

-(NSString *)getMediaUploadFile
{
    return [self getFile:@"mediaUpload.txt"];
}

- (NSString *)getFile:(NSString*) fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *documentsDirectory = [ paths objectAtIndex: 0 ];
    NSString *appFile = [ documentsDirectory stringByAppendingPathComponent: fileName ];
    return appFile;
}

-(void)loadMediaUpload
{
    NSString *appFile = [ self getMediaUploadFile ];
    
    _mediaUpload = [ NSKeyedUnarchiver unarchiveObjectWithFile: appFile ];
    if ( !_mediaUpload )
    {
        _mediaUpload = [ [ NSMutableArray alloc ] init ];
    }
}

-(void)saveMediaUpload
{
    NSMutableArray *mediaItemstoRemove = [ NSMutableArray arrayWithCapacity: _mediaUpload.count ];
    for( sc_Media *media in _mediaUpload )
    {

        if ( media.status == MEDIASTATUS_UPLOADED || media.status == MEDIASTATUS_REMOVED )
        {
            [ mediaItemstoRemove addObject: media ];
            
            [ self removeTmpVideoFileFromMediaItem: media ];
        }
    }
    [ _mediaUpload removeObjectsInArray: mediaItemstoRemove ];
    
    NSString *appFile = [ self getMediaUploadFile ];
    
    [ NSKeyedArchiver archiveRootObject: _mediaUpload
                                 toFile: appFile ];
}

-(void)removeTmpVideoFileFromMediaItem:(sc_Media *)media
{
    NSURL *videoUrl = [ media videoUrl ];
    if ( videoUrl != nil )
    {
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [ fileManager removeItemAtURL: videoUrl
                                error: &error ];
    }
}

-(BOOL)isOnline
{
    return [sc_ConnectivityHelper connectedToInternet];
}

@end
