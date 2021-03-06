//
//  sc_SitesSelectionViewController.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/18/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <UIKit/UIKit.h>

@class sc_GlobalDataObject;

@class UILabel;
@class UITableView;
@class NSString;

@interface sc_SitesSelectionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) IBOutlet UITableView *sitesTableView;
@property (nonatomic) IBOutlet UILabel* headerLabel;
@property ( nonatomic ) sc_GlobalDataObject* appDataObject;
@property ( nonatomic ) NSString* selectionType;

@end
