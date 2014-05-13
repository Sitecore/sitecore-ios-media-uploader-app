#import <Foundation/Foundation.h>


@protocol MULocationInfo <NSObject>

-(NSNumber*)latitude;
-(NSNumber*)longitude;
-(NSString*)locationDescription;
-(NSString*)countryCode;
-(NSString*)cityCode;

@end
