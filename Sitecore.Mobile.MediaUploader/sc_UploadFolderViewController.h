//
//  sc_UploadFolderViewController.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by Steve Jennings on 7/21/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sc_GlobalDataObject.h"
#import "sc_FolderHierarchy.h"
#import "sc_Site.h"

@class sc_SiteDataController;

@interface sc_UploadFolderViewController : sc_FolderHierarchy <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
    UIActivityIndicatorView *activityView;
    UIView *loadingView;
    UILabel *loadingLabel;
}

@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet UILabel *currentPathLabel;
@property (nonatomic, strong) UIActivityIndicatorView * activityView;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UILabel *loadingLabel;
@property sc_GlobalDataObject *appDataObject;
@property (nonatomic) IBOutlet UIBarButtonItem *useButton;
@property (nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end
