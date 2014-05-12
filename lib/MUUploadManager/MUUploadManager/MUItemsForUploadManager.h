#import <Foundation/Foundation.h>
#import <MUUploadManager/MUConstants.h>

@class MUMedia;

@interface MUItemsForUploadManager : NSObject

+(instancetype)new  __attribute__(( unavailable("Unsupported initializer") ));
-(instancetype)init __attribute__(( unavailable("Unsupported initializer") ));

/**
 
 @param rootDir A full path to the directory for storing list of connection records in.
 For example, "/PATH/TO/MediaUploaderSandbox/Documents/v1.1"
 
 @return A properly initialized object.
 */
-(instancetype)initWithCacheFilesRootDirectory:( NSString* )rootDir __attribute__((nonnull));


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
