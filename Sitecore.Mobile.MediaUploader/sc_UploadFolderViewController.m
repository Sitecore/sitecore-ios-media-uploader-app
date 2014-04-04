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
#import "sc_UploadFolderViewController.h"
#import "sc_SiteEditViewController.h"
#import "sc_GradientButton.h"
#import "sc_ItemHelper.h"

@interface sc_UploadFolderViewController ()
@property NSString *startingUploadFolder;
@property NSString *startingFolderId;
@property UIView *headerView;
@end

@implementation sc_UploadFolderViewController

-(void) setStartingFolder
{
//     NSString *rootFolderId = [ sc_Site mediaLibraryDefaultID ];
//    
//    if ( [ _startingFolderId isEqualToString: @"" ] )
//    {
//        self.itemId = rootFolderId;
//    }
//    else
//    {
//        self.itemId = _startingFolderId;
//        self.currentPathInsideMediaLibrary = _startingUploadFolder;
//    }
}

-(void)setCurrentSite:(sc_Site*) site
{
    [ super setCurrentSite:site ];
   
    _startingUploadFolder = site.uploadFolderPathInsideMediaLibrary;
}

-(NSMutableArray*) returnRequired: (NSMutableArray *) folderArray with: (NSMutableArray *) imageArray
{
    //Ignore images for folder picking
    return folderArray;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ self itemTapped:indexPath ];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [ tableView dequeueReusableCellWithIdentifier: identifier ];
    SCImageView *cellImageView = (SCImageView *)[ cell viewWithTag: 100 ];
    UILabel *label = (UILabel *)[ cell viewWithTag: 80 ];
    
    cellImageView.contentMode = UIViewContentModeCenter;
    [ cellImageView setImage: NULL ];
    label.text = @"";
    
    SCItem * cellObject = [ self.items objectAtIndex: indexPath.row ];
    
    //Cell can be image, folder, or back arrow
    NSString * itemType = [ sc_ItemHelper itemType: cellObject ];
    
    if ( [ itemType isEqualToString:@"folder" ] )
    {
        label.text = [ cellObject.displayName lowercaseString ];
        
         //NSString *rootFolderId = [ sc_Site mediaLibraryDefaultID ];
        
//        if ( indexPath.row == 0 && ![ self.itemId isEqualToString: rootFolderId ] )
//        {
//            [ cellImageView setImage: [ UIImage imageNamed: @"up_small.png" ] ];
//        }
//        else
//        {
//            [ cellImageView setImage: [ UIImage imageNamed: @"folder_small.png" ] ];
//        }
    }
    
    return cell;
}

-(NSInteger)tableView:(UICollectionView *)view numberOfRowsInSection:(NSInteger)section
{
    return [ self.items count ];
}

-(void)reloadCollection
{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)setCurrentPathLabelText
{
    self.navigationItem.title = self.currentFolder;
    
    self.currentSite.uploadFolderPathInsideMediaLibrary = self.currentPathInsideMediaLibrary;
}

-(NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

-(void)viewDidLoad
{
    _appDataObject = [ sc_GlobalDataObject getAppDataObject ];
    [ self initializeActivityIndicator ];
    [ super viewDidLoad ];
    
    //Localize UI
    _useButton.title = NSLocalizedString(_useButton.title, nil);
    _cancelButton.title =  NSLocalizedString(_cancelButton.title, nil);
    
    _useButton.target = self;
    _useButton.action = @selector(useButtonPushed:);
    
    _cancelButton.target = self;
    _cancelButton.action = @selector(cancelButtonPushed:);

    [ self setCurrentPathLabelText ];
}

-(IBAction)useButtonPushed:(id)sender
{
    sc_GlobalDataObject *globalDataObject = [ sc_GlobalDataObject getAppDataObject ];
    BOOL siteDouplicatesExists = [ globalDataObject.sitesManager sameSitesCount: self.currentSite ] > 1;
    
    if ( siteDouplicatesExists )
    {
        [ sc_ErrorHelper showError: NSLocalizedString(@"SITE_EXISTS_ERROR", nil) ];
        [ self cancelNewSettings ];
    }
    else
    {
        [ self setCurrentPathLabelText ];
        [ self.navigationController popViewControllerAnimated: YES ];
    }
    
}

-(IBAction)cancelButtonPushed:(id)sender
{
    [ self cancelNewSettings ];
}

-(void)cancelNewSettings
{
    self.currentSite.uploadFolderPathInsideMediaLibrary = _startingUploadFolder;
    [ self.navigationController popViewControllerAnimated: YES ];
}

@end
