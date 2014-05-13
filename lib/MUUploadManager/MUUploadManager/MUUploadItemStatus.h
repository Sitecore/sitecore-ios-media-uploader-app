#import <Foundation/Foundation.h>
#import <MUUploadManager/MUConstants.h>

@interface MUUploadItemStatus : NSObject

-(instancetype)init __attribute__(( unavailable("unsupported initializer") ));
+(instancetype)new  __attribute__(( unavailable("unsupported initializer") ));

-(instancetype)initWithStatusId:( MUUploadItemStatusType )statusId;
-(instancetype)initWithErrorDescription:(NSString*)statusDescription;

@property (nonatomic, readonly) MUUploadItemStatusType statusId;
@property (nonatomic, readonly) NSString* statusDescription;

@end
