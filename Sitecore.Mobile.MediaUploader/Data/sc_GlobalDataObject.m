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

-(void)initializeSites
{
    [ self loadSites ];
}

-(void)initializeMediaUpload
{
    [ self loadMediaUpload ];
}

-(void)addSite:(sc_Site*) site
{
    if ( [ _sites count ] == 0 )
    {
        site.selectedForUpdate = YES;
    }
    else
    {
        site.selectedForUpdate = NO;
    }
    
    [ _sites addObject: site ];
}

-(NSUInteger)sameSitesCount:(sc_Site*)site
{
    NSUInteger result = 0;
    
    for ( sc_Site *elem in self->_sites )
    {
        if ( [ elem isEqual: site ] )
        {
            ++result;
        }
    }
    
    return result;
}

-(BOOL)isSameSiteExist:(sc_Site*)site
{
    if ( [ self sameSitesCount: site ] == 0)
    {
        return NO;
    }
        
    return YES;
}

-(void)addMediaUpload:(sc_Media*) media
{
    [_mediaUpload addObject:media];
}

-(void)deleteSite:(sc_Site*) site
{
    [_sites removeObject:site];
}

-(NSString *)getSettingFile
{
    return [self getFile:@"sites.txt"];
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

-(void)loadSites
{
    
    NSString *appFile = [ self getSettingFile ];
    
    _sites = [ NSKeyedUnarchiver unarchiveObjectWithFile:appFile ];
    if ( !_sites )
    {
        _sites = [ [ NSMutableArray alloc ] init ];
    }
    
    [ self setSelecteForUploadSites ];
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

-(void)setSelecteForUploadSites
{
    _selectedForUploadsites = [ [ NSMutableArray alloc ] init ];
    
    for ( NSInteger i = 0; i < [ _sites count ]; ++i )
    {
        sc_Site *site = [ _sites objectAtIndex: i ];
        if ( site.selectedForUpdate )
        {
            [ _selectedForUploadsites addObject: site ];
        }
    }
}

-(sc_Site *)siteForBrowse
{
    for ( NSInteger i = 0; i < [ _sites count ]; ++i )
    {
        sc_Site *site = [ _sites objectAtIndex: i ];
        if (site.selectedForBrowse)
        {
            return site;
        }
    }

    return nil;
}

-(void)setSiteForUpload:(sc_Site *)siteForUpload
{
    for ( sc_Site *site in self.sites )
    {
        if ( [ site isEqual:siteForUpload ] )
        {
            site.selectedForUpdate = YES;
        }
        else
        {
            site.selectedForUpdate = NO;
        }
    }

    [ self saveSites ];
}

-(sc_Site *)siteForUpload
{
    for ( sc_Site *site in self.sites )
    {
        if ( site.selectedForUpdate )
        {
            return site;
        }
    }

    if ( [ self.sites count ] > 0 )
    {
        sc_Site *site = self.sites[0];
        site.selectedForUpdate = YES;
        return site;
    }
    
    NSLog(@"No sites");
    return nil;
}

-(void)saveSites
{
    [self setSelecteForUploadSites];
    NSString *appFile = [self getSettingFile];
    [NSKeyedArchiver archiveRootObject:_sites toFile:appFile];
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

-(NSUInteger)countOfList
{
    if(_sites == NULL)
    {
        return 0;
    }
    return [_sites count];
}

-(sc_Site *)objectInListAtIndex:(NSUInteger)theIndex
{
    if(_sites == NULL)
    {
        return NULL;
    }
    return [_sites objectAtIndex:theIndex];
}

-(NSUInteger)countOfSites
{
    return [ self->_sites count ] > 0;
}

-(sc_Site *)objectInSelectedForUploadListAtIndex:(NSUInteger)theIndex
{
    if(_selectedForUploadsites == NULL)
    {
        return NULL;
    }
    return [_selectedForUploadsites objectAtIndex:theIndex];
}

-(BOOL)isOnline
{
    return [sc_ConnectivityHelper connectedToInternet];
}

@end
