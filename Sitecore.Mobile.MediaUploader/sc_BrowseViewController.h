//
//  sc_BrosweViewController.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/4/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sc_GlobalDataObject.h"
#import "sc_ReloadableViewProtocol.h"
#import "sc_FolderHierarchy.h"

@class sc_SiteDataController, sc_GradientButton;

@interface sc_BrowseViewController : sc_FolderHierarchy <UICollectionViewDataSource, UICollectionViewDelegate, sc_ReloadableViewProtocol>
{
    UIActivityIndicatorView *activityView;
    UIView *loadingView;
    UILabel *loadingLabel;
}

@property (nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) IBOutlet UILabel *currentPathLabel;
@property (nonatomic) IBOutlet UILabel *singleSiteLabel;
@property (nonatomic) IBOutlet sc_GradientButton *siteButton;
@property (nonatomic) IBOutlet UILabel *siteLabel;
@property (nonatomic) IBOutlet UIView *singleSiteBgView;
@property sc_GlobalDataObject *appDataObject;

-(void) reload;
@end
