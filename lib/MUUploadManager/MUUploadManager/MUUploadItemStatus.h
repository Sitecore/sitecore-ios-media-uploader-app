#import <Foundation/Foundation.h>
#import <MUUploadManager/MUConstants.h>

@interface MUUploadItemStatus : NSObject

//TODO: @igk make readonly
@property (nonatomic) MUUploadItemStatusType statusId;
@property (nonatomic) NSString* statusDescription;

@end
