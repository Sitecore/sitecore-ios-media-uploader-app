#import <Foundation/Foundation.h>
#import <MUUploadManager/MUConstants.h>

@interface MUUploadItemStatus : NSObject

@property (nonatomic) MUUploadItemStatusType statusId;
@property (nonatomic) NSString* statusDescription;

@end
