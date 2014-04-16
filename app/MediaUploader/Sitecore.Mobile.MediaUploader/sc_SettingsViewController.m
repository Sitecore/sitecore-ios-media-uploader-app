//
//  sc_SettingsViewController.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/4/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_GlobalDataObject.h"
#import "sc_AppDelegateProtocol.h"
#import "sc_SettingsViewController.h"
#import "sc_SiteAddViewController.h"
#import "sc_UploadViewController.h"
#import "sc_Site.h"
#import "sc_ViewsHelper.h"
#import "sc_Constants.h"
#import "sc_ImageHelper.h"
#import "sc_ItemHelper.h"
#import "sc_BaseTheme.h"
#import "sc_SiteAddViewController.h"

@interface sc_SettingsViewController ()
@end

@implementation sc_SettingsViewController
{
    sc_BaseTheme *_theme;
}

-(void) reload
{
    [_sitesTableView reloadData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self->_theme  = [ sc_BaseTheme new ];
    
    self.navigationItem.title = NSLocalizedString(self.navigationItem.title, nil);
    _appDataObject = [sc_GlobalDataObject getAppDataObject];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController)
    {
        NSArray* viewControllers = [ self.navigationController viewControllers ];
        UIViewController* previusController = [ viewControllers objectAtIndex: viewControllers.count - 1 ];
        if ( ![ previusController isKindOfClass: [ sc_UploadViewController class ] ] )
        {
            [ sc_ViewsHelper reloadParentController: self.navigationController levels: 1 ];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.sitesTableView reloadData];
}

-(void)tableView:(UITableView*)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        sc_Site* siteToDelete = [_appDataObject.sitesManager siteAtIndex:indexPath.row];
        [ _appDataObject.sitesManager removeSite: siteToDelete ];
        [ self reload ];
    }
}

-(NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return NSLocalizedString(@"Sites", nil);
    }
    
    return NSLocalizedString(@"Upload image size", nil);
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return [_appDataObject.sitesManager sitesCount] + 1;
    }
    
    return 1;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0)
    {
        UITableViewCell *  cell =  [tableView dequeueReusableCellWithIdentifier:@"ImageSize" forIndexPath:indexPath];
        cell.backgroundView = [UIView new];
        UISegmentedControl *segmentedControl = (UISegmentedControl*)[cell viewWithTag:100];
        [segmentedControl setSelectedSegmentIndex:[sc_ImageHelper loadUploadImageSize]];
        [segmentedControl addTarget: self
                             action:@selector(segmentedControlChanged:)
                   forControlEvents:UIControlEventValueChanged];
        [segmentedControl setTitle:NSLocalizedString(@"Small", nil) forSegmentAtIndex:0];
        [segmentedControl setTitle:NSLocalizedString(@"Medium", nil) forSegmentAtIndex:1];
        [segmentedControl setTitle:NSLocalizedString(@"Actual", nil) forSegmentAtIndex:2];

        return cell;
    }
    
    if (indexPath.section == 1)
    {
        
        if (indexPath.row == [_appDataObject.sitesManager sitesCount])
        {
            UITableViewCell *  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AddNewSite"];
            cell.imageView.image = [UIImage imageNamed:@"empty_small.png"];
            cell.textLabel.text = NSLocalizedString(@"Add new site...", nil);
            cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        }
        
        UITableViewCell *  cell =  [tableView dequeueReusableCellWithIdentifier:@"cellSiteUrl" forIndexPath:indexPath];
        
        sc_Site* siteAtIndex = [_appDataObject.sitesManager siteAtIndex:indexPath.row];

        cell.textLabel.lineBreakMode = NSLineBreakByTruncatingHead;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingHead ;
        cell.textLabel.text = siteAtIndex.siteUrl;
        cell.detailTextLabel.text = [sc_ItemHelper formatUploadFolder: siteAtIndex];
        
        cell.accessoryView = [ self viewForAccessoryForIndexPath:indexPath ];
        
        //refactor
        cell.imageView.tag = indexPath.row;
        
        if ( siteAtIndex.selectedForUpload )
        {
            cell.imageView.image = [UIImage imageNamed:@"upload_small.png"];
            [ cell setBackgroundColor: [ self->_theme disableSiteBackgroundColor ] ];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"empty_upload_small.png"];
            [ cell setBackgroundColor: [ UIColor whiteColor ] ];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    return nil;
}

-(UIButton*)viewForAccessoryForIndexPath:(NSIndexPath*)indexPath
{
    UIButton *accButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [accButton setFrame:CGRectMake(0, 0, 40, 40)];
    [accButton setImage:[ UIImage imageNamed:@"accessoryArrow" ] forState:UIControlStateNormal];
    [accButton addTarget: self action:@selector(accessoryTapped:) forControlEvents:UIControlEventTouchUpInside];
    accButton.tag = indexPath.row;
    
    return accButton;
}

-(BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    return NO;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ( indexPath.section == 1 )
    {
        if ( indexPath.row == [ _appDataObject.sitesManager sitesCount ] )
        {
            sc_SiteAddViewController *siteAddViewController = (sc_SiteAddViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AddSite"];
            [self.navigationController pushViewController:siteAddViewController animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        else
        {
            sc_Site* siteAtIndex = [ _appDataObject.sitesManager siteAtIndex: indexPath.row ];
            [ _appDataObject.sitesManager setSiteForUpload: siteAtIndex ];
            [ self.sitesTableView reloadData ];
        }
    }

}

-(void)tableView:(UITableView*)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"bla");
}

-(void)accessoryTapped:(UIButton*)sender
{
    sc_Site* siteAtIndex = [ _appDataObject.sitesManager siteAtIndex: sender.tag ];

    sc_SiteAddViewController *siteEditViewController = (sc_SiteAddViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AddSite"];
    [ siteEditViewController setSiteForEdit: siteAtIndex ];
    [self.navigationController pushViewController:siteEditViewController animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [ textField resignFirstResponder ];
    return YES;
}

-(IBAction)segmentedControlChanged:(id)sender
{
    UISegmentedControl *segmentedControl = ( UISegmentedControl*)sender;
    [ sc_ImageHelper saveUploadImageSize: segmentedControl.selectedSegmentIndex ];
}

@end
