#import <Foundation/Foundation.h>

@class MUMedia;

typedef NS_ENUM(NSInteger, MUFilteringOptions)
{
    SHOW_ALL_ITEMS = 0,
    SHOW_COMLETED_ITEMS,
	SHOW_NOT_COMLETED_ITEMS,
};

@interface MUItemsForUploadManager : NSObject

@property (nonatomic, readonly) NSUInteger uploadCount;

-(void)addMediaUpload:(MUMedia* )media;
-(MUMedia*)mediaUploadAtIndex:(NSInteger)index;
-(BOOL)removeTmpVideoFileFromMediaItem:(MUMedia*)media error:(NSError**)error;
-(BOOL)removeMediaUpload:(MUMedia*)media error:(NSError**)error;
-(BOOL)removeMediaUploadAtIndex:(NSInteger)index error:(NSError**)error;

//filtering
-(void)setFilterOption:(MUFilteringOptions)option;

//TODO: @igk make items editing
-(void)save;
@end
