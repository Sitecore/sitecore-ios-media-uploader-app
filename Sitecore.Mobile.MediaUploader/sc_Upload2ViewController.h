//
//  sc_Upload2ViewController.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/20/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sc_GlobalDataObject.h"

@class sc_SiteDataController;

@interface sc_Upload2ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic) IBOutlet UITableView *sitesTableView;
@property (nonatomic) IBOutlet UIButton *abortButton;
@property (nonatomic) IBOutlet UISegmentedControl *filterControl;

@property sc_GlobalDataObject *appDataObject;

- (void) initWithMediaItems: (NSArray*) mediaItems image:(UIImage*) image isPendingIemsUploading: (BOOL) isPendingIemsUploading;
-(IBAction)changeFilter:(UISegmentedControl *)sender;
@end
