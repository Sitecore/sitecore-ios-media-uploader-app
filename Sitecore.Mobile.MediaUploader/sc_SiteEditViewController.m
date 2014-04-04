//
//  sc_SiteEditViewController.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 7/26/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_SiteEditViewController.h"
#import "sc_GlobalDataObject.h"
#import "sc_AppDelegateProtocol.h"
#import "sc_SettingsViewController.h"
#import "sc_Site.h"
#import "sc_ViewsHelper.h"
#import "sc_GradientButton.h"
#import "sc_Constants.h"
#import "sc_UploadFolderViewController.h"
#import "sc_SitesSelectionViewController.h"
#import "sc_ReloadableViewProtocol.h"
#import "sc_GradientButton.h"
#import "sc_ItemHelper.h"

@interface sc_SiteEditViewController ()
@property bool isNewSite;
@property UIView * footerView;
@end

@implementation sc_SiteEditViewController

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return NSLocalizedString(@"Site", nil);
    }
    
    return NSLocalizedString(@"Upload", nil);
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //Localize UI
    self.navigationItem.title = NSLocalizedString(self.navigationItem.title, nil);
    _headerLabelEnabled.text = NSLocalizedString(_headerLabelEnabled.text, nil);
    
    _appDataObject = [ sc_GlobalDataObject getAppDataObject ];
    
    self.navigationItem.hidesBackButton = YES;
    _doneButton.target = self;
    _doneButton.action = @selector(save:);
    _cancelButton.target = self;
    _cancelButton.action = @selector(goBack:);
    [ _selectedForUploadSwitch addTarget: self
                                  action: @selector(switchChanged:)
                        forControlEvents: UIControlEventValueChanged ];
}

-(void)viewWillAppear:(BOOL)animated
{
    [ self configureView ];
}

-(void)setSite:(sc_Site *) newSite isNew:(BOOL)isNew
{
    _isNewSite = isNew;
    if ( _site != newSite )
    {
        _site = newSite;
    }
}

-(void)switchChanged:(id)sender
{
    if ( _selectedForUploadSwitch.isOn )
    {
        _appDataObject.siteForUpload = self.site;
    }
}

-(void)reload
{
    [ self.tableView reloadData ];
}

-(void)configureView
{
    if (self->_site)
    {
        [ self setUploadMediaFolder: self->_site.uploadFolderPathInsideMediaLibrary
                             withId: self->_site.uploadFolderId ];
        
        self->_urlLabel.text = self->_site.siteUrl;
        self->_siteLabel.text = self->_site.site;
        
        self->_selectedForUploadSwitch.on = self->_site.selectedForUpdate;
    }
}


-(void)goBack:(id)sender
{
    if ( [ _appDataObject sameSitesCount: self->_site ] > 1 )
    {
        [ sc_ErrorHelper showError: NSLocalizedString( @"SITE_EXISTS_ERROR", nil ) ];
        return;
    }
    
    int levels = 2;
    if (_isNewSite)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        levels = 3;
    }
    
    UIViewController * viewController = [ sc_ViewsHelper reloadParentController: self.navigationController
                                                                         levels: levels ];
    if (viewController != nil)
    {
        [ self.navigationController popToViewController: viewController
                                               animated: YES ];
    }
}

-(void)save:(id)sender
{
    [ _appDataObject saveSites ];
    
    [ self goBack: nil ];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [ textField resignFirstResponder ];
    return YES;
}

-(void)setUploadMediaFolder:(NSString*)folder withId:(NSString*)folderId
{
    _site.uploadFolderPathInsideMediaLibrary = folder;
    _site.uploadFolderId = folderId;
    
    folder = [sc_ItemHelper formatUploadFolder:_site];
    _choosenFolderLabel.text = folder;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [ segue.identifier isEqualToString:@"UploadFolder" ] )
    {
        sc_UploadFolderViewController* destinationController = ( sc_UploadFolderViewController * ) segue.destinationViewController;
        [ destinationController setCurrentSite: _site ];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)validateUrl: (NSString *) candidate
{
    NSURL* url = [NSURL URLWithString:candidate];
    return !(url == NULL);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 80;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        if(_footerView == nil)
        {
            _footerView  = [[UIView alloc] init];
            
            int padding = 10;
            int fontSize = 18;
            int width = 136;
            if (_appDataObject.isIpad)
            {
                padding = 45;
                fontSize = 24;
                width = 260;
            }
            
            sc_GradientButton *button = [sc_GradientButton buttonWithType:UIButtonTypeCustom];
            [ button setButtonWithStyle:CUSTOMBUTTONTYPE_DANGEROUS ];
            [button setFrame:CGRectMake(padding, 35, width, 45)];
            [button setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
            [button addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
            [_footerView addSubview:button];
        }
    }

    return _footerView;
}

-(IBAction)delete:(id)sender
{
    [ _appDataObject deleteSite: _site ];
    [ _appDataObject saveSites ];
    
    [ sc_ViewsHelper reloadParentController: self.navigationController
                                     levels: 2 ];
    
    [ self.navigationController popViewControllerAnimated: YES ];
}

-(IBAction)dismissKeyboardOnTap:(id)sender
{
    [ [self view] endEditing: YES ];
}

@end

