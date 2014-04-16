//
//  sc_MapViewController.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/27/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <AddressBook/AddressBook.h>
#import "sc_ReloadableViewProtocol.h"
#import "sc_UploadViewController.h"
#import "sc_GlobalDataObject.h"
#import "sc_AppDelegateProtocol.h"
#import "sc_ImageHelper.h"
#import "sc_LocationManager.h"

typedef NS_ENUM(NSInteger, MapViewMode)
{
    MapViewModeNormal = 0,
    MapViewModeLoading,
};

@interface sc_MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray* mapItems;
@property (nonatomic, strong) MKLocalSearch *localSearch;
@property (nonatomic, strong) MKLocalSearchRequest *localSearchRequest;
@property (nonatomic) MapViewMode mapViewMode;
@property (nonatomic) CLLocationCoordinate2D coords;
@property (nonatomic) NSMutableArray* foundPlacemarks;
@property (nonatomic) CLPlacemark *currentPlacemark;
@end

@implementation sc_MapViewController

static CGFloat userPosZoomLat = 0.2f;
static CGFloat userPosZoomLon = 0.2f;
static CGFloat metersToKilimetersCoef = 1000.f;
static CGFloat beautifulRegionCoef = 112.f;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(self.navigationItem.title, nil);
    _useButton.title = NSLocalizedString(_useButton.title, nil);
    _cancelButton.title =  NSLocalizedString(_cancelButton.title, nil);
    
    _appDataObject = [sc_GlobalDataObject getAppDataObject];
    
    _searchBar.delegate = self;
    _mapView.delegate = self;
    
    _currentPlacemark = _appDataObject.selectedPlaceMark;
    [self initializeLocation];
    _cancelButton.target = self;
    _cancelButton.action = @selector(cancelButtonPushed:);
    
    [self initializeLocation];
    _useButton.target = self;
    _useButton.action = @selector(useButtonPushed:);

    [_currentLocationButton addTarget: self action:@selector(currentLocationButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget: self action:@selector(handleGesture:)];
    gestureRecognizer.minimumPressDuration = 0.2f;  //user must press for 1 second
    [_mapView addGestureRecognizer:gestureRecognizer];
}

-(void)initializeLocation
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    if (_currentPlacemark == nil)
    {
        [_locationManager startUpdatingLocation];
    }
    else
    {
        [self goToLocation:_currentPlacemark.location];
        [self setAnnotationFromPlacemark:_currentPlacemark];
    }
}

-(void)setAnnotationFromCoordinate:(CLLocationCoordinate2D)touchMapCoordinate
{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = touchMapCoordinate;
    [_mapView addAnnotation:annotation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *coord = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    [geocoder reverseGeocodeLocation:coord completionHandler:^(NSArray* placemarks, NSError* error) {
        
        if (error) {
            NSLog(@"Geocode failed with error");
        }
        
        self->_foundPlacemarks = [[NSMutableArray alloc] initWithArray:placemarks];
        
        if (placemarks && placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            annotation.title = [ sc_LocationManager getLocationDescriptionForPlacemark: placemark ];
            
            [self setSelectedPlaceMark:placemark];
        }
    }];
}

-(void)setAnnotationFromPlacemark:(CLPlacemark*) placemark
{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = placemark.location.coordinate;
    [self.mapView addAnnotation:annotation];
    annotation.title = [ sc_LocationManager getLocationDescriptionForPlacemark: placemark ];
    
    _foundPlacemarks = [[NSMutableArray alloc] initWithObjects:placemark, nil];
    [self setSelectedPlaceMark:placemark];
}

-(void)handleGesture:(UIGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;
    
    [_mapView removeAnnotations:_mapView.annotations];
    
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
    CLLocationCoordinate2D touchMapCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    [self setAnnotationFromCoordinate:touchMapCoordinate];
}

-(void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    _locationManager = nil;
    _mapItems = nil;
    _localSearch = nil;
    _localSearchRequest = nil;
}

-(void)setSelectedPlaceMark:(CLPlacemark*)placemark
{
    self.navigationItem.title = [ sc_LocationManager getLocationDescriptionForPlacemark: placemark ];
    _currentPlacemark = placemark;
}

-(void)goToLocation:(CLLocation*) location
{
    _coords = location.coordinate;
    
    [self centerOverUserLocation];
    CLGeocoder* reverseGeocoder = [[CLGeocoder alloc] init];
    [reverseGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarks, NSError* error)
    {
        self->_foundPlacemarks = [[NSMutableArray alloc] initWithArray:placemarks];
        if (placemarks.count > 0 )
        {
            [self setSelectedPlaceMark:[placemarks objectAtIndex:0]];
            return;
        }
    }];
}


-(void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation
{
    [_locationManager stopUpdatingLocation];
    [self goToLocation:newLocation];
}

-(void)centerOverUserLocation
{
    MKCoordinateSpan local = MKCoordinateSpanMake(userPosZoomLat, userPosZoomLon);
    MKCoordinateRegion region = MKCoordinateRegionMake(_coords, local);
    
    CLLocationCoordinate2D location;
    location.latitude = _coords.latitude;
    location.longitude = _coords.longitude;
    region.span = local;
    region.center = location;
    
    [_mapView setRegion:region animated:NO];
}

-(void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
    if (error.code == kCLErrorDenied)
    {
        [self.locationManager stopUpdatingLocation];
        
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Permission Denied", nil)
                                    message:NSLocalizedString(@"Please enable Map Services", nil)
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          otherButtonTitles:nil] show];
        
    }
    else if (error.code == kCLErrorLocationUnknown)
    {
        return;
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error retrieving location", nil)
                                    message:error.description
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          otherButtonTitles:nil] show];
    }
}

-(void)setMapViewMode:(MapViewMode)mapViewMode
{
    _mapViewMode = mapViewMode;
}

-(void)setPlacemark:(CLPlacemark*)placemark
{
    MKCoordinateRegion region;
    CLCircularRegion *placemarkRegion;

    if ( [ placemark.region isKindOfClass:[ CLCircularRegion class ] ] )
    {
        placemarkRegion = (CLCircularRegion*)placemark.region;
    }
    else
    {
        NSLog(@"Wrong region class");
        return;
    }
    
    CLLocationCoordinate2D placemarkCenter = [ placemarkRegion center ];
    CLLocationDistance placemarkRadius = [ placemarkRegion radius ];
    CLLocationDistance radius;
    
    region.center.latitude  = placemarkCenter.latitude;
    region.center.longitude = placemarkCenter.longitude;
    MKCoordinateSpan span;
    radius = placemarkRadius / metersToKilimetersCoef;
    
    span.latitudeDelta = radius / beautifulRegionCoef;
    
    region.span = span;
    [self setSelectedPlaceMark:placemark];
    [_mapView setRegion:region animated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    [_mapView removeAnnotations:_mapView.annotations];
    
    [_searchBar resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:_searchBar.text completionHandler:^(NSArray* placemarks, NSError* error)
    {
        self->_foundPlacemarks = [[NSMutableArray alloc] initWithArray:placemarks];
        
        if (placemarks.count > 0)
        {
            [self setPlacemark:[placemarks objectAtIndex:0]];
            return;
        }
        
    }];
}

-(void)searchBarCancelButtonClicked:(UISearchBar*) searchBar
{
    [searchBar resignFirstResponder];
}

-(IBAction) cancelButtonPushed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) useButtonPushed:(id)sender
{
    _appDataObject.selectedPlaceMark = _currentPlacemark;
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) currentLocationButtonPushed:(id)sender
{
    [_mapView removeAnnotations:_mapView.annotations];
    [_locationManager startUpdatingLocation];
}

@end
