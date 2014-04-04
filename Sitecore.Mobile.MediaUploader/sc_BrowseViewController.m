//
//  sc_BrosweViewController.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/4/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_GlobalDataObject.h"
#import "sc_AppDelegateProtocol.h"
#import "sc_BrowseViewController.h"
#import "sc_QuickImageViewController.h"
#import "sc_SitesSelectionViewController.h"
#import "sc_Site.h"
#import "sc_Constants.h"
#import "sc_ViewsHelper.h"
#import "sc_GradientButton.h"
#import "sc_ItemHelper.h"
#import "sc_BrowseCell.h"
#import "sc_BaseTheme.h"
#import "sc_SitesSelectionViewController.h"

@interface sc_BrowseViewController ()
@end

@implementation sc_BrowseViewController
{
    sc_BaseTheme *_theme;
}

-(void)setStartingFolder
{
    self.itemId = [ self.currentSite.uploadFolderId isEqualToString: @"" ] ? [ sc_Site mediaLibraryDefaultID ] : self.currentSite.uploadFolderId;
    [ self initializeCurrentPaths: self.currentSite ];
}

-(void)reload
{
    [ self.items removeAllObjects ];
    [ self.collectionView reloadData ];
    [ self reloadState ];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [ self itemTapped:indexPath ];
}
 
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    sc_BrowseCell *cell = [ collectionView dequeueReusableCellWithReuseIdentifier: identifier
                                                                     forIndexPath: indexPath ];

    SCItem * cellObject=[ self.items objectAtIndex: indexPath.row ];
    
    sc_CellType itemType = [ sc_ItemHelper scItemType: cellObject ];
    
    NSString *rootFolderId = [ sc_Site mediaLibraryDefaultID ];
    
    if ( itemType == FolderCellType && indexPath.row == 0 && ![ self.itemId isEqualToString: rootFolderId ] )
    {
        itemType = ArrowCellType;
    }
    
    [ cell setCellType: itemType
                  item: cellObject
               context: self.context ];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [ self.items count ];
}

-(void)setDefaultSite
{
    if ( !_appDataObject.sites || _appDataObject.sites.count == 0 )
    {
        _siteButton.hidden = YES;
        _singleSiteLabel.hidden = NO;
        _siteLabel.hidden = YES;
        _singleSiteLabel.text = NSLocalizedString(@"No sites defined", nil);
        return;
    }
    
    if ( _appDataObject.sites.count == 1 )
    {
        _siteButton.hidden = YES;
        _singleSiteLabel.hidden = NO;
        _siteLabel.hidden = YES;
        return;
    }
    
    _siteButton.hidden = NO;
    _singleSiteLabel.hidden = YES;
    _siteLabel.hidden = NO;

}

-(void)setContext
{
    sc_Site *site = [ _appDataObject siteForBrowse ];
    self.currentSite = site;
    
    [ super setContext ];
}

-(void)setCurrentSite:(sc_Site *)site
{
    [ super setCurrentSite: site ];
    
    if ( site )
    {
        [ self setSiteLabelWithSite: site ];
    }
    else
    {
        sc_Site* firstSite = ( (sc_Site *) [ _appDataObject.sites objectAtIndex: 0 ] );
        firstSite.selectedForBrowse = YES;
        [ super setCurrentSite: firstSite ];
        [ self setSiteLabelWithSite: firstSite ];
    }
}

-(void)setSiteLabelWithSite:(sc_Site *)site
{
    [ self setSiteLabelWithName: site.siteUrl ];
}

-(void)setSiteLabelWithName:(NSString *) siteName
{
    _siteLabel.text = siteName;
}

-(void)didSelectRow:(sc_Site*)selectedSite
{
    for ( sc_Site *site in _appDataObject.sites )
    {
        site.selectedForBrowse = NO;
    }
    
    selectedSite.selectedForBrowse = YES;
    
    [ self setSiteLabelWithSite: selectedSite ];
}

-(void)reloadCollection
{
    [ self.collectionView performBatchUpdates:
     ^{
        [ self.collectionView reloadSections: [ NSIndexSet indexSetWithIndex: 0 ] ];
      } completion: nil ];
  
}

-(void)folderChoosenWithPath:(NSString *)path displayName:(NSString *)displayName
{
    [ super folderChoosenWithPath: path displayName: displayName ];
    self.currentPathLabel.text = self.currentPathInsideSitecore;
}

-(void)setCurrentPathLabelText
{
    _currentPathLabel.text = self.currentPathInsideSitecore;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

-(void)refreshCurrentState
{
    [ self readContents ];
}

-(void)viewDidLoad
{
    //legacy, order matters
    _appDataObject = [ sc_GlobalDataObject getAppDataObject ];
    [ self initializeActivityIndicator ];
    [ self setDefaultSite ];
    
    [ super viewDidLoad ];
    
    self->_theme = [ sc_BaseTheme new ];
    
    //Localize UI
    self.navigationItem.title = NSLocalizedString(self.navigationItem.title, nil);
    
    UIBarButtonItem *backButton =
    [ [UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Home", nil)
                                      style: UIBarButtonItemStylePlain
                                     target: nil
                                     action: nil ];
    
    self.navigationController.navigationItem.backBarButtonItem = backButton;
    [ _singleSiteBgView setBackgroundColor: [ self->_theme labelBackgroundColor ] ];
    [ _siteButton setButtonWithStyle: CUSTOMBUTTONTYPE_NORMAL ];
    
    UIBarButtonItem *refreshButton =
    [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemRefresh
                                                     target: self
                                                     action: @selector(refreshCurrentState) ];

    self.navigationItem.rightBarButtonItem = refreshButton;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [ super viewWillDisappear: animated ];
    
    if ( self.isMovingFromParentViewController )
    {
        [ sc_ViewsHelper reloadParentController: self.navigationController
                                         levels: 1 ];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

@end

