#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MUUploadItemStatusType)
{
    READY_FOR_UPLOAD = 0,
    UPLOAD_IN_PROGRESS,
	UPLOAD_ERROR,
	UPLOAD_DONE,
    UPLOAD_CANCELED,
    DATA_IS_NOT_AVAILABLE
};

@interface MUUploadItemStatus : NSObject

@property (nonatomic) MUUploadItemStatusType statusId;
@property (nonatomic) NSString* description;
@property (nonatomic, readonly) NSString* localizedDescription;

@end
