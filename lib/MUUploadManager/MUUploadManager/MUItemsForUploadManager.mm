#import "MUItemsForUploadManager.h"
#import "MUMedia.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation MUItemsForUploadManager
{
    NSMutableArray* _mediaUpload;
    NSArray* _filteredMediaUpload;
    
    NSPredicate* _predicate;
}

-(instancetype)init
{
    if ( self = [ super init ])
    {
        [ self loadMediaUpload ];
        [ self performFilterPredicate: nil ];
    }
    
    return self;
}

-(void)performFilterPredicate:(NSPredicate*)predicate
{
    self->_predicate = predicate;
    
    if ( self->_predicate == nil )
    {
        self->_filteredMediaUpload = self->_mediaUpload;
    }
    else
    {
        self->_filteredMediaUpload = [ self->_mediaUpload filteredArrayUsingPredicate: predicate ];
    }
}

-(NSUInteger)uploadCount
{
    return [ self->_filteredMediaUpload count ];
}

-(void)addMediaUpload:(MUMedia*)media
{
    NSAssert([ media isMemberOfClass: [ MUMedia class ] ], @"object type must be MUMedia");

    [ self->_mediaUpload addObject: media];
    [ self saveUploadData ];
    
    [ self performFilterPredicate: self->_predicate ];
}

-(MUMedia*)mediaUploadAtIndex:(NSInteger)index
{
    MUMedia* objectToReturn = nil;
    
    NSUInteger arrayIndex = static_cast<NSUInteger>(index);
    objectToReturn = [ self->_filteredMediaUpload objectAtIndex: arrayIndex ];
    
    [ self checkResourceAvailabilityForUploadItem: objectToReturn ];
    
    return objectToReturn;
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

-(void)removeMediaUpload:(MUMedia*)media error:(NSError**)error
{
    [ self removeTmpVideoFileFromMediaItem: media
                                     error: error];
    [ self->_mediaUpload removeObject: media ];
    [ self saveUploadData ];
    
    [ self performFilterPredicate: self->_predicate ];
}

-(void)removeMediaUploadAtIndex:(NSInteger)index error:(NSError**)error
{
    NSUInteger arrayIndex = static_cast<NSUInteger>(index);
    MUMedia* media = self->_mediaUpload[arrayIndex];
    [ self removeMediaUpload: media
                       error: error ];
}

-(void)saveUploadData
{
    NSString* appFile = [ self getMediaUploadFile ];
    
    [ NSKeyedArchiver archiveRootObject: self->_mediaUpload
                                 toFile: appFile ];
}

-(void)removeTmpVideoFileFromMediaItem:(MUMedia*)media error:(NSError**)error
{
    NSURL* videoUrl = [ media videoUrl ];
    if ( videoUrl != nil )
    {
        NSFileManager* fileManager = [NSFileManager defaultManager];
        [ fileManager removeItemAtURL: videoUrl
                                error: error ];
    }
}

-(NSString*)getMediaUploadFile
{
    return [self getFile:@"mediaUpload.dat"];
}

-(NSString*)getFile:(NSString*)fileName
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString* documentsDirectory = [ paths objectAtIndex: 0 ];
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
        
        if ( [ uploadItem.videoUrl checkResourceIsReachableAndReturnError: &err ] == NO )
        {
            uploadItem.uploadStatus.statusId = DATA_IS_NOT_AVAILABLE;
        }
    }
}

-(void)checkImageAvailabilityForUploadItem:(MUMedia*)uploadItem
{
    if ( uploadItem.isImage )
    {
        ALAssetsLibrary *library = [ [ALAssetsLibrary alloc] init ];
        [ library assetForURL: uploadItem.imageUrl resultBlock:^(ALAsset *asset)
        {
            if (!asset)
            {
                uploadItem.uploadStatus.statusId = DATA_IS_NOT_AVAILABLE;
            }
            
        }
        failureBlock:^(NSError* error)
        {
            NSLog(@"image checking error: %@", [error description]);
        } ];
    }
}

@end
