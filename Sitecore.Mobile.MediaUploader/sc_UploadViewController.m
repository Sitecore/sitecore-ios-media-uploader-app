//
//  sc_UploadViewController.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/2/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <ImageIO/CGImageProperties.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "sc_GlobalDataObject.h"
#import "sc_AppDelegateProtocol.h"
#import "sc_UploadViewController.h"
#import "sc_Upload2ViewController.h"
#import "sc_SitesSelectionViewController.h"
#import "sc_Site.h"
#import "sc_Constants.h"
#import <MediaPlayer/MediaPlayer.h>
#import "sc_Media.h"
#import "sc_GradientButton.h"
#import "sc_ActivityIndicator.h"
#import "sc_Validator.h"
#import "sc_ImageHelper.h"
#import "sc_ItemHelper.h"
#import "sc_BaseTheme.h"

#import <AddressBook/AddressBook.h>

static const float slideDistance = 75;
static const float slideDuration = 0.3f;

@interface sc_UploadViewController ()
@property CLLocation *currentLocation;
@property UIImage *thumbnail;
@property bool autoImagePickerLoadExecuted;
@property sc_ActivityIndicator * activityIndicator;
@property BOOL isRaised;

@property float latitude;
@property float longitude;
@property NSDate * timeStamp;
@property NSString * countryCode;
@property NSString * cityCode;
@end

@implementation sc_UploadViewController
{
    UIImageView *imageView;
    BOOL newMedia;
    CLLocationManager *locationManager;
    
    BOOL isFirstAppear;
    sc_BaseTheme *_theme;
    
    UIImagePickerController *_imagePicker;
}
@synthesize imageView;

-(IBAction)slideFrameUp;
{
    if (_isRaised)
    {
        return;
    }
    [self slideFrame:YES];
    _isRaised = YES;
}

-(IBAction)slideFrameDown;
{
    if (!_isRaised)
    {
        return;
    }
    [self slideFrame:NO];
    _isRaised = NO;
}

-(void)slideFrame:(BOOL)up
{
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: slideDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, (up ? -slideDistance : slideDistance));
    [UIView commitAnimations];
}


-(void)reload
{
    [imageView setImage: nil];
    _name.text = @"";
    _locationDescription.text = NSLocalizedString(@"Location undefined", nil);
    _appDataObject.selectedPlaceMark = nil;
    [self hideUploadForm: YES];
    _autoImagePickerLoadExecuted = NO;
}

-(void)viewDidLoad
{
    isFirstAppear = YES;
    
    [super viewDidLoad];
    self->_theme = [ sc_BaseTheme new ];
    //Localize UI
    self.navigationItem.title = NSLocalizedString(self.navigationItem.title, nil);
    _name.placeholder = NSLocalizedString(_name.placeholder, nil);
    
    [ _uploadButton setTitle: NSLocalizedString(_uploadButton.titleLabel.text, nil)
                    forState: UIControlStateNormal ];
    
    [ _saveButton setTitle: NSLocalizedString(_saveButton.titleLabel.text, nil)
                  forState: UIControlStateNormal ];
    
    self->_appDataObject = [sc_GlobalDataObject getAppDataObject];
    
    _autoImagePickerLoadExecuted = NO;
    
    [self reload];
    self->_uploadButton.hidden = YES;
    
    [_imageButton addTarget:self action:@selector(useCameraRoll:) forControlEvents:UIControlEventTouchUpInside];
    [_backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [_saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    _name.delegate = self;
    
    [(sc_GradientButton*) _saveButton setButtonWithStyle:CUSTOMBUTTONTYPE_NORMAL];
    [(sc_GradientButton*) _imageButton setButtonWithStyle:CUSTOMBUTTONTYPE_TRANSPARENT];
    [(sc_GradientButton*) _uploadButton setButtonWithStyle:CUSTOMBUTTONTYPE_IMPORTANT];
    [(sc_GradientButton*) _locationButton setButtonWithStyle:CUSTOMBUTTONTYPE_NORMAL];
    
    [ _locationView setBackgroundColor: [ self->_theme labelBackgroundColor ] ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _dismissKeyboardButton.hidden = YES;
    
    if (self->_appDataObject.IOS >= 7)
    {
        [_settingsButton setImage:[UIImage imageNamed:@"settings.png"]];
    }
    
    _uploadButton.enabled = (imageView.image != NULL);
}

-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear: animated ];
    
    _locationDescription.text = [sc_ImageHelper formatLocation:_appDataObject.selectedPlaceMark];

    [ self checkAndShowUploadButton ];
    
    
    //spike to hide upload button while image will be chosen on ipad
    if ( self->_appDataObject.isIpad && isFirstAppear )
    {
        self.uploadButton.hidden = YES;
    }
    isFirstAppear = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear: animated ];
    
    if (!_autoImagePickerLoadExecuted)
    {
        [ self showCameraRoll ];
        _autoImagePickerLoadExecuted = YES;
    }
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [locationManager stopUpdatingLocation];
}

-(void)getCurrentLocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    _currentLocation = [locationManager location];
    
}

-(IBAction)useCameraRoll: (id)sender
{
    [ self showCameraRoll ];
}

-(void)showCameraRoll
{
    if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        self->_imagePicker = [[UIImagePickerController alloc] init];
        self->_imagePicker.delegate = self;
        self->_imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSArray *mediaTypesAllowed = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self->_imagePicker setMediaTypes:mediaTypesAllowed];
        
        self->_imagePicker.allowsEditing = NO;
        [self presentViewController:self->_imagePicker animated:YES completion:nil];
    }
        
    newMedia = NO;
}

-(void)getReadableLocation:(CLLocation *)location
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error)
    {
       NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
       
       if (error)
       {
           _appDataObject.selectedPlaceMark = nil;
           NSLog(@"Geocode failed with error: %@", error);
           return;
       }
       
       if (placemarks.count > 0)
       {
           CLPlacemark *placemark = [placemarks objectAtIndex:0];
           _appDataObject.selectedPlaceMark = placemark;
       }
       else
       {
           _appDataObject.selectedPlaceMark = nil;
       }
       
       _locationDescription.text = [sc_ImageHelper formatLocation:_appDataObject.selectedPlaceMark];
       _countryCode = _appDataObject.selectedPlaceMark.ISOcountryCode;
       _cityCode = _appDataObject.selectedPlaceMark.postalCode;
        
    }];
}

-(IBAction)dismissKeyboardOnTap:(id)sender
{
    [[self view] endEditing:YES];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    [self hideUploadForm: NO];
    _uploadButton.enabled = NO;
    
    // IMAGE
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [imageView setImage: image];
        
        _uploadButton.enabled = YES;
        
        _videoUrl = nil;
        
        if (newMedia)
        {
            if (_appDataObject.isOnline)
            {
                [self getReadableLocation:_currentLocation];
            }
            else
            {
                // TODO: Deal with situation where we have no readableLocation
            }
            
            [self getLatLong:_currentLocation];
            _timeStamp = [NSDate date];
            
            NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
            
            // Handle a still image capture
            if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)== kCFCompareEqualTo)
            {
                
                UIImage *imageToSave = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
                
                // Set the image metadata
                UIImagePickerControllerSourceType pickerType = picker.sourceType;
                if(pickerType == UIImagePickerControllerSourceTypeCamera)
                {
                    NSMutableDictionary *imageMetadata = [info objectForKey: UIImagePickerControllerMediaMetadata];
                    
                    [imageMetadata setObject:[self gpsDictionaryForLocation:_currentLocation] forKey:(NSString*)kCGImagePropertyGPSDictionary];
                    
                    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                    ALAssetsLibraryWriteImageCompletionBlock imageWriteCompletionBlock;
                    
                    // Get the assets library
                    imageWriteCompletionBlock =
                    ^(NSURL *newURL, NSError *error)
                    {
                        if (error)
                        {
                            NSLog( @"Error writing image with metadata to Photo Library: %@", error );
                        }
                        else
                        {
                            NSLog( @"Wrote image with metadata to Photo Library");
                            _imageUrl = newURL;
                        }
                        
                        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                        {
                            CGImageRef iref = [myasset thumbnail];
                            if (iref)
                            {
                                _thumbnail = [UIImage imageWithCGImage:iref];
                            }
                        };
                        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror)
                        {
                            NSLog(@"cant get image - %@", [myerror localizedDescription]);
                        };
                        
                        
                        [library assetForURL:_imageUrl resultBlock:resultblock failureBlock:failureblock];
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                    };
                    
                    // Save the new image to the Camera Roll
                    [library writeImageToSavedPhotosAlbum:[imageToSave CGImage]
                                                 metadata:imageMetadata
                                          completionBlock:imageWriteCompletionBlock];
                    
                }
            }
        }
        else
        {
            // NOT NEW MEDIA
            
            //Extract metadata
            NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
            if (url)
            {
                
                _imageUrl = url;
                ALAssetsLibrary *assetsLib = [[ALAssetsLibrary alloc] init];
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
                    
                    //Get timestamp from asset
                    _timeStamp = [myasset valueForProperty:ALAssetPropertyDate];
                    
                    //Get location data from asset
                    CLLocation *location = [myasset valueForProperty:ALAssetPropertyLocation];
                    [self getReadableLocation:location];
                    [self getLatLong:location];
                    
                    CGImageRef iref = [myasset thumbnail];
                    if (iref)
                    {
                        _thumbnail = [UIImage imageWithCGImage:iref];
                    }
                };
                ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror)
                {
                    NSLog(@"cant get image - %@", [myerror localizedDescription]);
                };
                
                
                [assetsLib assetForURL:url resultBlock:resultblock failureBlock:failureblock];
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
    // VIDEO
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        
        _imageUrl = nil;
        _videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString *moviePath = [_videoUrl path];
        
        if (newMedia)
        {
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath))
            {
                UISaveVideoAtPathToSavedPhotosAlbum (moviePath, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
            }
            
            if(_appDataObject.isOnline)
            {
                [self getReadableLocation:_currentLocation];
                [self getLatLong:_currentLocation];
                _timeStamp = [NSDate date];
            }
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        _thumbnail = [sc_ImageHelper getVideoThumbnail:_videoUrl];
        [imageView setImage: _thumbnail];
        
        _uploadButton.enabled = YES;
    }
}

- (void)getLatLong: (CLLocation *)loc
{
    _latitude = loc.coordinate.latitude;
    _longitude = loc.coordinate.longitude;
}

- (void)moviePlayBackDidFinish:(NSNotification *)notification
{
    NSLog(@"Playback finished");
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Save failed", nil)
                                                        message: NSLocalizedString(@"Failed to save media item", nil)
                                                       delegate: nil
                                              cancelButtonTitle: NSLocalizedString(@"OK", nil)
                                              otherButtonTitles: nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [ self cancel: nil ];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender
{
    [self saveFileAsPending];
}

- (sc_Media *)getMedia
{
    
    sc_Media *media = [ [sc_Media alloc] initWithObjectData: _name.text
                                                   dateTime: _timeStamp
                                                   latitude: [NSNumber numberWithFloat:_latitude]
                                                  longitude: [NSNumber numberWithFloat:_longitude]
                                        locationDescription: _locationDescription.text
                                                countryCode: _countryCode
                                                   cityCode: _cityCode
                                                   videoUrl: _videoUrl
                                                   imageUrl: _imageUrl
                                                     status: MEDIASTATUS_PENDING
                                                  thumbnail: _thumbnail ];
    
    media.siteForUploading = self.appDataObject.siteForUpload;
    
    return media;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [ [self view] endEditing: YES ];
    
    if ([segue.identifier isEqualToString:@"upload2"])
    {
        [ self initializeActivityIndicator ];
        [ _activityIndicator showWithLabel: @"Preparing media" ];
        
        sc_Media *media = [ self getMedia ];
        
        [ _activityIndicator hide ];
        
        if ( media.siteForUploading == nil )
        {
            [ sc_ErrorHelper showError:NSLocalizedString(@"Please set up at least one upload site.", nil) ];
            return;
        }
        
        [ self setMediaItemValidName: media ];
        
        sc_Upload2ViewController * destinationController = ( sc_Upload2ViewController * ) segue.destinationViewController;
        
        NSArray *mediaItems = @[ media ];
        [ destinationController initWithMediaItems: mediaItems
                                             image: imageView.image
                            isPendingIemsUploading: NO ];
        
        
    }
}

- (void)saveFileAsPending
{
    sc_Media *media = [self getMedia];
    
    if ( media.siteForUploading == nil )
    {
        [ sc_ErrorHelper showError:NSLocalizedString(@"Please set up at least one upload site.", nil) ];
        return;
    }
    
    [self setMediaItemValidName:media];
    [_appDataObject addMediaUpload:media];
    [_appDataObject saveMediaUpload];
    
    [self.navigationController popViewControllerAnimated:YES ];
}

-(void)setMediaItemValidName: (sc_Media *) media
{
    NSString *validName;
    
    if (media.videoUrl != nil)
    {
        validName = @"Video";
    }
    else
    {
        validName = @"Image";
    }
    
    media.name = [sc_Validator proposeValidItemName:media.name withDefault:[sc_ItemHelper generateItemName:validName]];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"upload2"])
    {
        if (!_appDataObject.isOnline)
        {
            [self saveFileAsPending];
            
            return NO;
        }
    }
    return YES;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation];
}

- (NSDictionary *) gpsDictionaryForLocation:(CLLocation *)location
{
    //Helper to create a dictionary of geodata to be incorporate into photo metadata
    CLLocationDegrees exifLatitude  = location.coordinate.latitude;
    CLLocationDegrees exifLongitude = location.coordinate.longitude;
    
    NSString * latRef;
    NSString * longRef;
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
    
    NSMutableDictionary *locDict = [[NSMutableDictionary alloc] init];
    
    [locDict setObject:[NSDate date] forKey:(NSString*)kCGImagePropertyGPSTimeStamp];
    [locDict setObject:latRef forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
    [locDict setObject:[NSNumber numberWithFloat:exifLatitude] forKey:(NSString *)kCGImagePropertyGPSLatitude];
    [locDict setObject:longRef forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
    [locDict setObject:[NSNumber numberWithFloat:exifLongitude] forKey:(NSString *)kCGImagePropertyGPSLongitude];
    [locDict setObject:[NSNumber numberWithFloat:location.horizontalAccuracy] forKey:(NSString*)kCGImagePropertyGPSDOP];
    [locDict setObject:[NSNumber numberWithFloat:location.altitude] forKey:(NSString*)kCGImagePropertyGPSAltitude];
    
    return locDict;
}

-(void)navigationController: (UINavigationController *) navigationController  willShowViewController: (UIViewController *) viewController animated: (BOOL) animated
{
    BOOL isPhotoLibraryActive = ( _imagePicker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary );
    BOOL isFirstScreenActive = [ navigationController.viewControllers count ] == 1;
    
    if( isPhotoLibraryActive && isFirstScreenActive )
    {
        UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(showCamera:)];
        viewController.navigationItem.rightBarButtonItems = [NSArray arrayWithObject:button];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    }
}

-(void)cancel:(id)sender
{
    if ( imageView.image == nil )
    {
        [ self dismissViewControllerAnimated: NO
                                  completion: nil ];
        
        [ self.navigationController popViewControllerAnimated: YES ];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showCamera:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        [self getCurrentLocation];
        self->_imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSArray *mediaTypesAllowed = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self->_imagePicker setMediaTypes:mediaTypesAllowed];
        self->_imagePicker.allowsEditing = NO;
        self->_imagePicker.showsCameraControls = YES;
        
        newMedia = YES;
    }
    else
    {
        [ sc_ErrorHelper showError: NSLocalizedString(@"CAMERA_NOT_AVAILABLE", nil) ];
    }
}

-(void)initializeActivityIndicator
{
    _activityIndicator = [[sc_ActivityIndicator alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_activityIndicator];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    if ([self.view window])
    {
        _dismissKeyboardButton.hidden = YES;
    }
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    if ([self.view window])
    {
        _dismissKeyboardButton.hidden = NO;
    }
}

-(void) showError:(NSString*) message
{
    UIAlertView *alert = [ [UIAlertView alloc] initWithTitle: @""
                                                     message: message
                                                    delegate: nil
                                           cancelButtonTitle: @"OK"
                                           otherButtonTitles: nil ];
    [alert show];
}

-(void) hideUploadForm:(BOOL) status
{
    [ self checkAndShowUploadButton ];
    _saveButton.hidden   = status;
    _locationView.hidden = status;
    _name.hidden         = status;
}

-(void)checkAndShowUploadButton
{
    BOOL instanceAvailable = self->_appDataObject.countOfSites > 0;
    
    if ( self->_appDataObject.isOnline && instanceAvailable )
    {
        self->_uploadButton.hidden = NO;
        self->_locationButton.hidden = NO;
    }
    else
    {
        self->_uploadButton.hidden = YES;
        self->_locationButton.hidden = YES;
    }
}

@end
