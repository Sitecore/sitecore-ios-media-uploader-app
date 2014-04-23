#import "MUItemsForUploadManager.h"
#import "MUMedia.h"

@implementation MUItemsForUploadManager

-(instancetype)init
{
    if ( self = [ super init ])
    {
        [ self loadMediaUpload ];
    }
    
    return self;
}

-(NSUInteger)uploadCount
{
    return [ self->_mediaUpload count ];
}

-(void)addMediaUpload:(MUMedia*)media
{
    NSAssert([ media isMemberOfClass: [ MUMedia class ] ], @"object type must be MUMedia");

    [ self->_mediaUpload addObject: media];
    [ self saveUploadData ];
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

-(void)removeMediaUpload:(MUMedia*)media
{
    media.status = MEDIASTATUS_REMOVED;
    [ self removeTmpVideoFileFromMediaItem: media ];
    [ self->_mediaUpload removeObject: media ];
    [ self saveUploadData ];
}

-(void)removeMediaUploadAtIndex:(NSInteger)index
{
    MUMedia* media = self->_mediaUpload[index];
    [ self removeMediaUpload: media ];
}

-(void)saveMediaUpload
{
    NSMutableArray* mediaItemstoRemove = [ NSMutableArray arrayWithCapacity: self->_mediaUpload.count ];
    for ( MUMedia* media in self->_mediaUpload )
    {
        if ( media.status == MEDIASTATUS_UPLOADED || media.status == MEDIASTATUS_REMOVED )
        {
            [ mediaItemstoRemove addObject: media ];
            
            [ self removeTmpVideoFileFromMediaItem: media ];
        }
    }
    [ self->_mediaUpload removeObjectsInArray: mediaItemstoRemove ];
    
    [ self saveUploadData ];
}

-(void)saveUploadData
{
    NSString* appFile = [ self getMediaUploadFile ];
    
    [ NSKeyedArchiver archiveRootObject: self->_mediaUpload
                                 toFile: appFile ];
}

-(void)removeItem:(MUMedia*)media
{
    [ self->_mediaUpload removeObject: media ];
    [ self saveUploadData ];
}

-(void)removeTmpVideoFileFromMediaItem:(MUMedia*)media
{
    NSURL* videoUrl = [ media videoUrl ];
    if ( videoUrl != nil )
    {
        NSError* error;
        NSFileManager* fileManager = [NSFileManager defaultManager];
        [ fileManager removeItemAtURL: videoUrl
                                error: &error ];
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

@end
