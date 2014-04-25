#import <Foundation/Foundation.h>

@class MUMedia;

@interface MUItemsForUploadManager : NSObject

@property (nonatomic, readonly) NSUInteger uploadCount;

//TODO: @igk remove from public, refactor sc_ResourseCleaner
//@property (nonatomic)  NSMutableArray* mediaUpload;

-(void)addMediaUpload:(MUMedia* )media;
-(MUMedia*)mediaUploadAtIndex:(NSInteger)index;
-(void)removeTmpVideoFileFromMediaItem:(MUMedia*)media;
-(void)removeMediaUpload:(MUMedia*)media;
-(void)removeMediaUploadAtIndex:(NSInteger)index;
-(void)performFilterPredicate:(NSPredicate*)predicate;

@end
