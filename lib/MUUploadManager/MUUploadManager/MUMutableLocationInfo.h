#import <Foundation/Foundation.h>


@protocol MUMutableLocationInfo <NSObject>

-(void)setLongitude:(NSNumber*)longitude;
-(void)setLocationDescription:(NSString*)locationDescription;
-(void)setCountryCode:(NSString*)countryCode;
-(void)setCityCode:(NSString*)cityCode;
-(void)setLatitude:(NSNumber*)latitude;

@end
