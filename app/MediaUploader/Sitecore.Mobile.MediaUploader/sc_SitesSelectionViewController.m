//
//  sc_SitesSelectionViewController.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/18/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_SitesSelectionViewController.h"
#import "sc_GlobalDataObject.h"
#import "sc_AppDelegateProtocol.h"
#import "sc_UploadViewController.h"
#import "sc_Site.h"
#import "sc_Constants.h"
#import "sc_ReloadableViewProtocol.h"
#import "sc_ViewsHelper.h"
#import "sc_ItemHelper.h"

@interface sc_SitesSelectionViewController ()
@property ( nonatomic ) NSIndexPath *selectedIndex;
@property ( nonatomic ) sc_Site* selectedSite;
@end

@implementation sc_SitesSelectionViewController

@synthesize sitesTableView = _sitesTableView;
@synthesize appDataObject = _appDataObject;

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ _appDataObject.sitesManager sitesCount ];
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone)
    {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        newCell.highlighted = YES;
    }
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_selectedIndex];
    if (oldCell != newCell)
    {
        if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            oldCell.highlighted = NO;
        }
    }

    _selectedIndex = indexPath;
    _selectedSite = [ _appDataObject.sitesManager siteAtIndex: indexPath.row ];
    
    [self closeView];
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifier = @"cellSiteUrl";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    sc_Site* currentSite = [_appDataObject.sitesManager siteAtIndex:indexPath.row];
    [ [cell textLabel] setText: currentSite.siteUrl ];
    cell.detailTextLabel.text = [sc_ItemHelper formatUploadFolder: currentSite];
    
    [ _sitesTableView setAllowsSelection: YES ];
    
    _headerLabel.text = NSLocalizedString(@"Select the site you wish to browse.", nil);
    [ _sitesTableView setAllowsMultipleSelection: NO ];
    
    if (currentSite.selectedForBrowse)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.selected = YES;
        _selectedIndex = indexPath;
        _selectedSite = currentSite;
        cell.highlighted = YES;
        [ tableView selectRowAtIndexPath: indexPath
                                animated: NO
                          scrollPosition: UITableViewScrollPositionNone ];

    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selected = NO;
    }
    
    return cell;
}

-(BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    return NO;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"Browsing site", nil);
    _appDataObject = [sc_GlobalDataObject getAppDataObject];
}

-(IBAction)goBack:(id)sender
{
    [self closeView];
}

-(IBAction)closeView
{    
    [ _appDataObject.sitesManager setSiteForBrowse: _selectedSite ];
    
    [ sc_ViewsHelper reloadParentController: self.navigationController
                                     levels: 2 ];
    
    [ self.navigationController popViewControllerAnimated: YES ];
}

@end
