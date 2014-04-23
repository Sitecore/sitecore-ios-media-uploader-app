#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MUUploadItemStatusType)
{
    inProgressStatus = 0,
	errorStatus,
	doneStatus,
    canceledStatus
};

@interface MUUploadItemStatus : NSObject

@property (nonatomic) MUUploadItemStatusType statusId;
@property (nonatomic) NSString* description;
@property (nonatomic, readonly) NSString* localizedDescription;

@end
