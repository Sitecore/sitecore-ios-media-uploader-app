#import <Foundation/Foundation.h>
#import <MUUploadManager/MUTypes.h>


@interface MUUploadItemStatus : NSObject

@property (nonatomic) MUUploadItemStatusType statusId;
@property (nonatomic) NSString* statusDescription;

@end
