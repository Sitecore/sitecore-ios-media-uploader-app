//
//  sc_SiteEditViewController.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 7/26/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sc_Site.h"
#import "sc_GlobalDataObject.h"
#import "sc_ReloadableViewProtocol.h"

@interface sc_SiteEditViewController : UITableViewController <UITextFieldDelegate, sc_ReloadableViewProtocol>
@property (strong, nonatomic) sc_Site *site;
@property (nonatomic) IBOutlet UISwitch *selectedForUploadSwitch;
@property (nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic) IBOutlet UILabel *choosenFolderLabel;
@property (nonatomic) IBOutlet UILabel *urlLabel;
@property (nonatomic) IBOutlet UILabel *siteLabel;
@property (nonatomic) IBOutlet UILabel *headerLabelEnabled;
@property (nonatomic) IBOutlet UITableView *siteTableView;

@property sc_GlobalDataObject *appDataObject;

- (IBAction)setUploadMediaFolder:(NSString*) folder withId:(NSString*) folderId;
- (void)setSite:(sc_Site *) newSite isNew:(BOOL) isNew;
- (IBAction)dismissKeyboardOnTap:(id)sender;

@end
