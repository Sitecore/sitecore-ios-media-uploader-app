#import <Foundation/Foundation.h>
#import "sc_Media.h"

enum
{
    MEDIASTATUS_UNDEFINED = 0,
    MEDIASTATUS_PENDING,
    MEDIASTATUS_UPLOADED,
    MEDIASTATUS_REMOVED,
    MEDIASTATUS_ERROR
};


@interface sc_ItemsForUploadManager : NSObject

@property (nonatomic, readonly) NSUInteger uploadCount;

//TODO: @igk remove from public, refactor sc_ResourseCleaner
@property (nonatomic)  NSMutableArray* mediaUpload;

-(void)loadMediaUpload;
-(void)saveMediaUpload;
-(void)addMediaUpload:(sc_Media*)media;
-(void)removeTmpVideoFileFromMediaItem:(sc_Media*)media;
-(void)removeMediaUpload:(sc_Media*)media;
-(void)removeMediaUploadAtIndex:(NSInteger)index;

@end
