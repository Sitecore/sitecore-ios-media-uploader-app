#import <Foundation/Foundation.h>

@class MUMedia;

enum
{
    MEDIASTATUS_UNDEFINED = 0,
    MEDIASTATUS_PENDING,
    MEDIASTATUS_UPLOADED,
    MEDIASTATUS_REMOVED,
    MEDIASTATUS_ERROR
};


@interface MUItemsForUploadManager : NSObject

@property (nonatomic, readonly) NSUInteger uploadCount;

//TODO: @igk remove from public, refactor sc_ResourseCleaner
@property (nonatomic)  NSMutableArray* mediaUpload;

-(void)loadMediaUpload;
-(void)saveMediaUpload;
-(void)addMediaUpload:(MUMedia*)media;
-(void)removeTmpVideoFileFromMediaItem:(MUMedia*)media;
-(void)removeMediaUpload:(MUMedia*)media;
-(void)removeMediaUploadAtIndex:(NSInteger)index;

@end
