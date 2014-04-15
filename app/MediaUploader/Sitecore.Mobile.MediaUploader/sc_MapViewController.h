//
//  sc_MapViewController.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/27/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sc_GlobalDataObject.h"

@interface sc_MapViewController : UIViewController
@property (nonatomic) IBOutlet UIButton *currentLocationButton;
@property (nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic) IBOutlet UIBarButtonItem *useButton;
@property (nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) sc_GlobalDataObject *appDataObject;
@end
