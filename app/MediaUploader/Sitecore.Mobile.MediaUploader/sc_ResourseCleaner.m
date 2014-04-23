#import "sc_ResourseCleaner.h"
#import "sc_GlobalDataObject.h"
#import "sc_CleaningProtocol.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation sc_ResourseCleaner
{
    NSInteger _removedVideosCount;
    NSInteger _removedImagesCount;
    sc_GlobalDataObject* _appDataObject;
    
    BOOL _videoIsChecked;
    BOOL _imagesIsChecked;
    
    NSInteger _imagesRequestsCount;
}

-(id)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(id)initWithDelegate:(id<sc_CleaningProtocol>)delegate
{
    if (( self = [ super init ] ))
    {
        self.delegate = delegate;
        self->_appDataObject = [ sc_GlobalDataObject getAppDataObject ];
    }
    
    return self;
}

-(void)checkResoursesAvailability
{
    self->_removedVideosCount = 0;
    self->_removedImagesCount = 0;
    self->_videoIsChecked = NO;
    self->_imagesIsChecked = NO;
    
    [ self checkVideoAvailability ];
    [ self checkImagesAvailability ];
}

-(void)checkVideoAvailability
{
    for ( sc_Media* item in _appDataObject.uploadItemsManager.mediaUpload )
    {
        if ( item.isVideo )
        {
            NSError* err;
            
            if ( [ item.videoUrl checkResourceIsReachableAndReturnError: &err ] == NO )
            {
                ++self->_removedVideosCount;
                item.status = MEDIASTATUS_REMOVED;
            }
        }
    }
    
    self->_videoIsChecked = YES;
    [ self checkingFinished ];
}

-(void)checkImagesAvailability
{
    __weak sc_ResourseCleaner *weakSelf = self;
    self->_imagesRequestsCount = 0;
    for ( sc_Media* item in _appDataObject.uploadItemsManager.mediaUpload )
    {
        if ( item.isImage )
        {
            ++self->_imagesRequestsCount;
            ALAssetsLibrary *library = [ [ALAssetsLibrary alloc] init ];
            [ library assetForURL:item.imageUrl resultBlock:^(ALAsset *asset){
                
                if (!asset)
                {
                    ++self->_removedImagesCount;
                    item.status = MEDIASTATUS_REMOVED;
                }
                
                [ weakSelf imageChecked ];
                
            } failureBlock:^(NSError* error)
             {
                 [ weakSelf imageChecked ];
             } ];
        }
    }
}

-(void)imageChecked
{
    --self->_imagesRequestsCount;
    if (self->_imagesRequestsCount == 0)
    {
        self->_imagesIsChecked = YES;
        [ self checkingFinished ];
    }
}

-(void)checkingFinished
{
    if ( self->_imagesIsChecked && self->_videoIsChecked )
    {
        [_appDataObject.uploadItemsManager saveMediaUpload];
        NSInteger removedCount = self->_removedImagesCount + self->_removedVideosCount;
        [ self.delegate cleaningComplete: removedCount ];
    }
}

@end
