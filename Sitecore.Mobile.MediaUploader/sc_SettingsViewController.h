//
//  sc_SettingsViewController.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/4/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sc_ReloadableViewProtocol.h"


@interface sc_SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, sc_ReloadableViewProtocol>
@property (nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic) IBOutlet UIBarButtonItem *addSiteButton;
@property (nonatomic) IBOutlet UITableView *sitesTableView;
@property sc_GlobalDataObject *appDataObject;

-(void)reload;
@end
