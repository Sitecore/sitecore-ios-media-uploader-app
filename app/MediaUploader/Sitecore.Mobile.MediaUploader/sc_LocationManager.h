#import <Foundation/Foundation.h>

@interface sc_LocationManager : NSObject< CLLocationManagerDelegate >

@property (nonatomic, readonly) CGFloat latitude;
@property (nonatomic, readonly) CGFloat longitude;

-(NSString *)getCurrentLocationDescription;
+(NSString *)getLocationDescriptionForPlacemark:(CLPlacemark *)placemark;
-(NSDictionary *)gpsDictionaryForCurrentLocation;
-(void)setCurrentLocation:(CLLocation *)location;

-(NSString *)getCountryCode;
-(NSString *)getCityCode;
-(CGFloat)getLatitude;
-(CGFloat)getLongitude;

@end
