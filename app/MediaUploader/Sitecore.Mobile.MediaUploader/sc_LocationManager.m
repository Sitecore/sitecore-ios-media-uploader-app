#import "sc_LocationManager.h"
#import "sc_GlobalDataObject.h"
#import <ImageIO/CGImageProperties.h>

@implementation sc_LocationManager
{
    CLLocationManager* _locationManager;
    CLLocation* _currentLocation;
    sc_GlobalDataObject* _appDataObject;
}


-(id)init
{
    if (( self = [ super init ] ))
    {
        self->_appDataObject = [sc_GlobalDataObject getAppDataObject];
        [ self initLocationManager ];
    }
    
    return self;
}

-(void)initLocationManager
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [_locationManager startUpdatingLocation];
    [ self setCurrentLocation: [_locationManager location] ];
}

-(void)setCurrentLocation:(CLLocation*)location
{
    self->_currentLocation = location;
    [ self getReadableLocation: _currentLocation ];
}

-(void)getReadableLocation:(CLLocation*)location
{
    CLGeocoder* geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray* placemarks, NSError* error)
     {
         NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
         
         if (error)
         {
             self->_appDataObject.selectedPlaceMark = nil;
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         
         if (placemarks.count > 0)
         {
             CLPlacemark* placemark = [placemarks objectAtIndex:0];
             self->_appDataObject.selectedPlaceMark = placemark;
         }
         else
         {
             self->_appDataObject.selectedPlaceMark = nil;
         }
         
     }];
}

-(NSString*)getCurrentLocationDescription
{
    return [ [self class] getLocationDescriptionForPlacemark: _appDataObject.selectedPlaceMark ];
}

-(NSString*)getCountryCode
{
    return _appDataObject.selectedPlaceMark.ISOcountryCode;
}

-(NSString*)getCityCode
{
    return _appDataObject.selectedPlaceMark.postalCode;
}

-(void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
    [_locationManager stopUpdatingLocation];
}

-(CLLocationDegrees)getLatitude
{
    return _appDataObject.selectedPlaceMark.location.coordinate.latitude;
}

-(CLLocationDegrees)getLongitude
{
    return _appDataObject.selectedPlaceMark.location.coordinate.longitude;
}

-(void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation
{
    [ self setCurrentLocation: newLocation ];
}

-(NSDictionary*)gpsDictionaryForCurrentLocation
{
    //Helper to create a dictionary of geodata to be incorporate into photo metadata
    CLLocationDegrees exifLatitude  = _currentLocation.coordinate.latitude;
    CLLocationDegrees exifLongitude = _currentLocation.coordinate.longitude;
    
    NSString*  latRef  = nil;
    NSString*  longRef = nil;
    if (exifLatitude < 0.0)
    {
        exifLatitude = exifLatitude * -1.0f;
        latRef = @"S";
    }
    else
    {
        latRef = @"N";
    }
    
    if (exifLongitude < 0.0)
    {
        exifLongitude = exifLongitude * -1.0f;
        longRef = @"W";
    }
    else
    {
        longRef = @"E";
    }
    
    
    NSDate* nowDate = [ self nowDate ];
    NSNumber* exifLatitudeNumber  = [ NSNumber numberWithDouble: exifLatitude  ];
    NSNumber* exifLongitudeNumber = [ NSNumber numberWithDouble: exifLongitude ];
    
    NSNumber* horizontalAccuracy = [NSNumber numberWithDouble: self->_currentLocation.horizontalAccuracy];
    NSNumber* altitude = [NSNumber numberWithDouble:_currentLocation.altitude];
    
    NSDictionary* locDict =
    @{
      (NSString*)kCGImagePropertyGPSTimeStamp    : nowDate            ,
      (NSString*)kCGImagePropertyGPSLatitudeRef  : latRef             ,
      (NSString*)kCGImagePropertyGPSLongitudeRef : longRef            ,
      (NSString*)kCGImagePropertyGPSLatitude     : exifLatitudeNumber ,
      (NSString*)kCGImagePropertyGPSLongitude    : exifLongitudeNumber,
      (NSString*)kCGImagePropertyGPSDOP          : horizontalAccuracy ,
      (NSString*)kCGImagePropertyGPSAltitude     : altitude
    };
    
    return locDict;
}

// @ADK : can be used for mocking
-(NSDate*)nowDate
{
    return [ NSDate date ];
}

+(NSString*)getLocationDescriptionForPlacemark:(CLPlacemark*)placemark
{
    
    if (placemark == nil)
    {
        return NSLocalizedString(@"Location undefined", nil);
    }
    
    NSString*  ISOcountryCode = placemark.ISOcountryCode;
    if (ISOcountryCode == nil)
    {
        ISOcountryCode = @"";
    }
    
    NSString* locality = placemark.locality;
    if (locality == nil)
    {
        locality = @"";
    }
    
    NSString* subLocality = placemark.subLocality;
    if (subLocality == nil)
    {
        subLocality = @"";
    }
    
    NSString* thoroughfare = placemark.thoroughfare;
    if (thoroughfare == nil)
    {
        thoroughfare = @"";
    }
    
    NSString* subThoroughfare = placemark.subThoroughfare;
    if (subThoroughfare == nil)
    {
        subThoroughfare = @"";
    }
    
    
    if (ISOcountryCode.length == 0 && locality.length == 0 && subLocality.length == 0 && thoroughfare.length == 0 && subThoroughfare.length == 0)
    {
        return NSLocalizedString(@"Location undefined", nil);
    }
    
    return [NSString stringWithFormat:@"%@, %@, %@, %@ %@", ISOcountryCode, locality, subLocality, thoroughfare, subThoroughfare];
}

@end
