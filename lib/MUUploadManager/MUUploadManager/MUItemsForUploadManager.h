#import <Foundation/Foundation.h>
#import <MUUploadManager/MUTypes.h>

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

-(NSInteger)indexOfMediaUpload:(MUMedia* )media;
-(MUMedia*)mediaUploadAtIndex:(NSInteger)index;
-(void)removeMediaUploadAtIndex:(NSInteger)index error:(NSError**)error;
-(void)setUploaStatus:(MUUploadItemStatusType)status
      withDescription:(NSString *)description
forMediaUploadAtIndex:(NSInteger)index;

//filtering
-(void)setFilterOption:(MUFilteringOptions)option;

//TODO: @igk implement items editing!!!
-(void)save;
@end
