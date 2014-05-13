#import "MUItemsForUploadManager.h"
#import "MUMedia.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import "MUMedia+Private.m"

@implementation MUItemsForUploadManager
{
    NSMutableArray* _mediaUpload;
    NSMutableArray* _filteredMediaUpload;
    
    NSPredicate* _predicate;
    
    MUFilteringOptions _currentFilterOption;
    
    NSString* _rootDir;
}

-(instancetype)initWithCacheFilesRootDirectory:( NSString* )rootDir __attribute__((nonnull))
{
    NSParameterAssert( nil != rootDir );
    
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }
    
    
    // @adk : order matters
    self->_rootDir = rootDir;
    [ self loadMediaUpload ];
    [ self setFilterOption: SHOW_ALL_ITEMS ];
    
    
    return self;
}

-(BOOL)isUploadItemComplete:(MUMedia*)uploadItem
{
    return      uploadItem.uploadStatusData.statusId == UPLOAD_DONE
    ||  uploadItem.uploadStatusData.statusId == DATA_IS_NOT_AVAILABLE;
}

-(void)setFilterOption:(MUFilteringOptions)option
{
    switch (option)
    {
        case SHOW_ALL_ITEMS:
        {
            self->_filteredMediaUpload = self->_mediaUpload;
            break;
        }
        case SHOW_COMLETED_ITEMS:
        {
            self->_filteredMediaUpload = [NSMutableArray new];
            for ( MUMedia *elem in self->_mediaUpload )
            {
                if ( [ self isUploadItemComplete: elem ] )
                {
                    [ self->_filteredMediaUpload addObject:elem ];
                }
            }
            break;
        }
            
        case SHOW_NOT_COMLETED_ITEMS:
        {
            self->_filteredMediaUpload = [NSMutableArray new];
            for ( MUMedia *elem in self->_mediaUpload )
            {
                if ( ![ self isUploadItemComplete: elem ] )
                {
                    [ self->_filteredMediaUpload addObject:elem ];
                }
            }
            break;
        }
    }
    
    self->_currentFilterOption = option;
}

-(NSUInteger)uploadCount
{
    return [ self->_filteredMediaUpload count ];
}

-(void)addMediaUpload:(MUMedia*)media
{
    NSAssert(media != nil, @"object type must not be nil");
    NSAssert([ media isMemberOfClass: [ MUMedia class ] ], @"object type must be MUMedia");

    [ self->_mediaUpload addObject: media];
    [ self saveUploadData ];
    
    [ self setFilterOption: self->_currentFilterOption ];
}

-(void)setUploadStatus:(MUUploadItemStatusType)status
       withDescription:(NSString*)description
        forMediaUpload:(MUMedia*)media
{
    NSParameterAssert( [ self->_mediaUpload containsObject: media ] );
       
    media.uploadStatusData.statusId = status;
    media.uploadStatusData.statusDescription = description;
    
    BOOL videoShouldBeRemovedFromTempStorage = media.isVideo && status == UPLOAD_DONE;
    if ( videoShouldBeRemovedFromTempStorage )
    {
        [ self removeTmpVideoFileFromMediaItem: media
                                         error: NULL ];
    }
    
    [ self saveUploadData ];
}

-(MUMedia*)mediaUploadAtIndex:(NSInteger)index
{
    NSUInteger castedIndex = static_cast<NSUInteger>( index );

    if ([self isIndexOutOfRange:castedIndex])
    {
        throw std::runtime_error( "index is out of range" );
    }
    
    MUMedia* objectToReturn = nil;
    
    objectToReturn = [ self->_filteredMediaUpload objectAtIndex: castedIndex ];
    
    [ self checkResourceAvailabilityForUploadItem: objectToReturn ];
    
    return objectToReturn;
}

-(MUMedia*)mediaUploadWithUploadStatus:(MUUploadItemStatusType)status
{
    NSUInteger barIndex = [self->_mediaUpload indexOfObjectPassingTest:^BOOL(MUMedia* obj, NSUInteger idx, BOOL *stop)
    {
        if ( obj.uploadStatusData.statusId == status )
        {
            return YES;
        }
        return NO;
    }];
    
    if ( barIndex != NSNotFound )
    {
        return self->_mediaUpload[ barIndex ];
    }
    
    return nil;
}

-(NSInteger)indexOfMediaUpload:(MUMedia* )media
{
    return static_cast<NSInteger>( [ self->_filteredMediaUpload indexOfObject: media ] );
}

-(BOOL)isIndexOutOfRange:(NSUInteger)index
{
    return self.uploadCount <= index;
}

-(void)loadMediaUpload
{
    NSString* appFile = [ self getMediaUploadFile ];
    
    self->_mediaUpload = [ NSKeyedUnarchiver unarchiveObjectWithFile: appFile ];
    if ( !self->_mediaUpload )
    {
        self->_mediaUpload = [ [ NSMutableArray alloc ] init ];
    }
}

-(BOOL)removeMediaUpload:(MUMedia*)media error:(NSError**)error
{
    BOOL removeTmpResult = [ self removeTmpVideoFileFromMediaItem: media
                                                            error: error];
    if ( !removeTmpResult )
    {
        return NO;
    }
    
    [ self->_mediaUpload removeObject: media ];
    [ self saveUploadData ];
    
    [ self setFilterOption: self->_currentFilterOption ];

    return YES;
}

-(BOOL)removeMediaUploadAtIndex:(NSInteger)index error:(NSError**)error
{
    NSUInteger castedIndex = static_cast<NSUInteger>( index );
    
    if ( [self isIndexOutOfRange:castedIndex] )
    {
        throw std::runtime_error( "index is out of range" );
    }
    
    MUMedia* media = self->_mediaUpload[ castedIndex ];
    return [ self removeMediaUpload: media
                              error: error ];
}

-(void)save
{
    [ self saveUploadData ];
}

-(void)saveUploadData
{
    NSString* appFile = [ self getMediaUploadFile ];
    
    [ NSKeyedArchiver archiveRootObject: self->_mediaUpload
                                 toFile: appFile ];
}

-(BOOL)removeTmpVideoFileFromMediaItem:(MUMedia*)media error:(NSError**)error
{
    NSURL* videoUrl = [ media videoUrl ];
    if ( videoUrl != nil )
    {
        NSFileManager* fileManager = [NSFileManager defaultManager];
        return [ fileManager removeItemAtURL: videoUrl
                                       error: error ];
    }
    else
    {
        return YES;
    }
}

-(NSString*)getMediaUploadFile
{
    return [self getFile:@"mediaUpload.dat"];
}

-(NSString*)getFile:(NSString*)fileName
{
    NSString* documentsDirectory = self->_rootDir;
    NSString* appFile = [ documentsDirectory stringByAppendingPathComponent: fileName ];
    
    return appFile;
}

-(void)checkResourceAvailabilityForUploadItem:(MUMedia*)uploadItem
{
    if( uploadItem.isVideo )
    {
        [ self checkVideoAvailabilityForUploadItem: uploadItem ];
    }
    else
    {
        [ self checkImageAvailabilityForUploadItem: uploadItem ];
    }
}

-(void)checkVideoAvailabilityForUploadItem:(MUMedia*)uploadItem
{
    if ( uploadItem.isVideo )
    {
        NSError* err;
        if ( uploadItem.uploadStatusData.statusId != UPLOAD_DONE )
        {
            if ( [ uploadItem.videoUrl checkResourceIsReachableAndReturnError: &err ] == NO )
            {
                uploadItem.uploadStatusData.statusId = DATA_IS_NOT_AVAILABLE;
                uploadItem.uploadStatusData.statusDescription = @"VIDEO_NOT_EXISTS";
            }
        }
    }
}

-(void)checkImageAvailabilityForUploadItem:(MUMedia*)uploadItem
{
    if ( uploadItem.uploadStatusData.statusId != UPLOAD_DONE )
    {
        if ( uploadItem.isImage )
        {
            ALAssetsLibrary *library = [ [ALAssetsLibrary alloc] init ];
            [ library assetForURL: uploadItem.imageUrl resultBlock:^(ALAsset *asset)
            {
                if (!asset)
                {
                    uploadItem.uploadStatusData.statusId = DATA_IS_NOT_AVAILABLE;
                    uploadItem.uploadStatusData.statusDescription = @"IMAGE_NOT_EXISTS";
                }
                
            }
            failureBlock:^(NSError* error)
            {
                uploadItem.uploadStatusData.statusId = DATA_IS_NOT_AVAILABLE;
                uploadItem.uploadStatusData.statusDescription = error.localizedDescription;
            } ];
        }
    }
}

-(void)relaceStatus:(MUUploadItemStatusType)oldStatus
         withStatus:(MUUploadItemStatusType)newStatus
        withMessage:(NSString*)message
{
    for ( MUMedia* elem in self->_mediaUpload )
    {
        if ( elem.uploadStatusData.statusId == oldStatus )
        {
            elem.uploadStatusData.statusId = newStatus;
            elem.uploadStatusData.statusDescription = message;
        }
    }
    
    [ self setFilterOption: self->_currentFilterOption ];
}

@end
