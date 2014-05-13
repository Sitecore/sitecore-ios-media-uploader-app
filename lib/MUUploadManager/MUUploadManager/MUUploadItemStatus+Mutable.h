#import "MUUploadItemStatus.h"

@interface MUUploadItemStatus (Mutable)

@property (nonatomic, readwrite) MUUploadItemStatusType statusId;
@property (nonatomic, readwrite) NSString* statusDescription;

@end
