#import <Foundation/Foundation.h>

@class MUMedia;

@interface MUItemsForUploadManager : NSObject

@property (nonatomic, readonly) NSUInteger uploadCount;

-(void)addMediaUpload:(MUMedia* )media;
-(MUMedia*)mediaUploadAtIndex:(NSInteger)index;
-(void)removeTmpVideoFileFromMediaItem:(MUMedia*)media error:(NSError**)error;
-(void)removeMediaUpload:(MUMedia*)media error:(NSError**)error;
-(void)removeMediaUploadAtIndex:(NSInteger)index error:(NSError**)error;
-(void)performFilterPredicate:(NSPredicate*)predicate;

@end
