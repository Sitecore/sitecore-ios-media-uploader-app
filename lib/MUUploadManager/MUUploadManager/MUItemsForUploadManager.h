#import <Foundation/Foundation.h>
#import <MUUploadManager/MUConstants.h>

@class MUMedia;

@interface MUItemsForUploadManager : NSObject

@property (nonatomic, readonly) NSUInteger uploadCount;

-(void)addMediaUpload:(MUMedia* )media;

-(NSInteger)indexOfMediaUpload:(MUMedia* )media;
-(MUMedia*)mediaUploadAtIndex:(NSInteger)index;
-(BOOL)removeMediaUploadAtIndex:(NSInteger)index error:(NSError**)error;

-(void)setUploadStatus:(MUUploadItemStatusType)status
       withDescription:(NSString *)description
 forMediaUploadAtIndex:(NSInteger)index;

-(MUMedia*)mediaUploadWithUploadStatus:(MUUploadItemStatusType)status;

//filtering
-(void)setFilterOption:(MUFilteringOptions)option;

//TODO: @igk implement items editing!!!
-(void)save;

-(void)relaceStatus:(MUUploadItemStatusType)oldStatus
         withStatus:(MUUploadItemStatusType)newStatus
        withMessage:(NSString*)message;
@end
