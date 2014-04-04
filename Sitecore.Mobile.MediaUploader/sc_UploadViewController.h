//
//  sc_UploadViewController.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/2/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreLocation/CoreLocation.h>
#import "sc_GlobalDataObject.h"
#import "sc_ReloadableViewProtocol.h"
#import <MediaPlayer/MediaPlayer.h>

@interface sc_UploadViewController : UIViewController <UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, sc_ReloadableViewProtocol>

@property (nonatomic) IBOutlet UIButton *dismissKeyboardButton;
@property (nonatomic) IBOutlet UIButton *locationButton;
@property (nonatomic) IBOutlet UIButton *imageButton;
@property (nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic) IBOutlet UIButton *uploadButton;
@property (nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) IBOutlet UITextField *name;
@property (nonatomic) IBOutlet UILabel *locationDescription;
@property (nonatomic) IBOutlet NSURL *videoUrl;
@property (nonatomic) IBOutlet NSURL *imageUrl;
@property (nonatomic) IBOutlet UIView *locationView;
@property (nonatomic) IBOutlet UIBarButtonItem *settingsButton;

@property ( nonatomic ) sc_GlobalDataObject *appDataObject;

- (IBAction)useCameraRoll: (id)sender;
- (IBAction)dismissKeyboardOnTap:(id)sender;

-(void) reload;
@end
