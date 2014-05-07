//
//  sc_Upload2ViewController.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/20/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <UIKit/UIKit.h>


@class sc_GlobalDataObject;
@class SCSiteDataController;


@interface sc_Upload2ViewController : UIViewController
<
    UITableViewDelegate  ,
    UITableViewDataSource,
    UIAlertViewDelegate
>

@property (nonatomic) IBOutlet UITableView* sitesTableView;
@property (nonatomic) IBOutlet UIButton* abortButton;
@property (nonatomic) IBOutlet UISegmentedControl* filterControl;

@property (nonatomic) sc_GlobalDataObject* appDataObject;

-(IBAction)changeFilter:(UISegmentedControl*)sender;
-(IBAction)homePressed:(id)sender;
@end
