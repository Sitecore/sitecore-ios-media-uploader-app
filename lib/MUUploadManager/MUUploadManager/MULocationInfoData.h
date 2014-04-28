#import <Foundation/Foundation.h>
#import <MUUploadManager/MULocationInfo.h>

@interface MULocationInfoData : NSObject<MULocationInfo>

@property (nonatomic) NSNumber* latitude;
@property (nonatomic) NSNumber* longitude;
@property (nonatomic) NSString* locationDescription;
@property (nonatomic) NSString* countryCode;
@property (nonatomic) NSString* cityCode;

@end
