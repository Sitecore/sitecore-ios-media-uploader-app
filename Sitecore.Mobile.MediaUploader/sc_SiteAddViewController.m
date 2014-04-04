//
//  sc_SiteEditViewController.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 7/26/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_SiteAddViewController.h"
#import "sc_SiteEditViewController.h"
#import "sc_GlobalDataObject.h"
#import "sc_AppDelegateProtocol.h"
#import "sc_SettingsViewController.h"
#import "sc_Site.h"
#import "sc_GradientButton.h"
#import "sc_Constants.h"
#import "sc_UploadFolderViewController.h"
#import "sc_ActivityIndicator.h"
#import "sc_ErrorHelper.h"
#import "sc_ItemHelper.h"

@interface sc_SiteAddViewController ()

@property BOOL loggedIn;
@property UIView* loginFooterView;
@property sc_ActivityIndicator * activityIndicator;
@property UIView* footerView;

@end

@implementation sc_SiteAddViewController
{
    sc_GlobalDataObject *_appDataObject;
    UIBarButtonItem *_saveButton;
    
    sc_Site *_siteForEdit;
    BOOL editModeEnabled;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self->_siteForEdit = [ sc_Site emptySite ];
    editModeEnabled = NO;
    
    [ self localizeUI ];
    [ self initializeActivityIndicator ];
    
    _appDataObject = [sc_GlobalDataObject getAppDataObject];
    
    self.navigationItem.hidesBackButton = YES;
    
    _cancelButton.target = self;
    _cancelButton.action = @selector(cancel:);
    
    _loggedIn = NO;
    
    [ self configureView ];
}

- (void)initializeActivityIndicator
{
    _activityIndicator = [[sc_ActivityIndicator alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_activityIndicator];
}

-(void)setSiteForEdit:(sc_Site *)site
{
    self->_siteForEdit = site;
    editModeEnabled = YES;
    [ self configureView ];
}

-(void)localizeUI
{
    self.navigationItem.title      = NSLocalizedString(self.navigationItem.title, nil);
    _passwordTextField.placeholder = NSLocalizedString(_passwordTextField.placeholder, nil);
    _usernameTextField.placeholder = NSLocalizedString(_usernameTextField.placeholder, nil);
    _urlTextField.placeholder      = NSLocalizedString(_urlTextField.placeholder, nil);
    _siteTextField.placeholder     = NSLocalizedString(_siteTextField.placeholder, nil);
    _cancelButton.title            = NSLocalizedString(_cancelButton.title, nil);
}

-(void)configureView
{
    _urlTextField.text      = self->_siteForEdit.siteUrl;
    _siteTextField.text     = self->_siteForEdit.site;
    _usernameTextField.text = self->_siteForEdit.username;
    _passwordTextField.text = self->_siteForEdit.password;
}

-(void)authenticateAndSaveSite:(sc_Site *)site
{
    __block sc_Site *tmpSite = site;
    __block BOOL editMode = editModeEnabled;
    
    SCApiSession *session = [ sc_ItemHelper getContext: tmpSite ];
    
    SCAsyncOp asyncOp = [ session checkCredentialsOperationForSite: site.site ];
    
    [ _activityIndicator showWithLabel: NSLocalizedString(@"Authenticating", nil) ];
    
    asyncOp(^( id result, NSError *error )
    {
        [ _activityIndicator hide ];
        if ( !error )
        {
            {

                NSError *error;
                
                if ( editMode )
                {
                    [ _appDataObject.sitesManager saveSites ];
                }
                else
                {
                    [ _appDataObject.sitesManager addSite: tmpSite
                                                    error: &error ];
                }
                
                _loggedIn = YES;
                                    
                sc_SiteEditViewController * siteEditViewController = (sc_SiteEditViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"SiteEdit" ];
                [ siteEditViewController setSite: tmpSite
                                           isNew: YES ];
                
                [ self.navigationController pushViewController: siteEditViewController
                                                      animated: YES ];
            }
        }
        else
        {
            [ sc_ErrorHelper showError: NSLocalizedString(@"Authentication failure.", nil) ];
        }
    });
}

-(IBAction)cancel:(id)sender
{
    [ self.navigationController popViewControllerAnimated: YES ];
}


-(IBAction)save:(id)sender
{
    if(![self validateUrl:_urlTextField.text])
    {
        [ sc_ErrorHelper showError: NSLocalizedString(@"Please enter a valid site url.", nil) ];
        return;
    }
    
    if(_usernameTextField.text.length > 0 && _passwordTextField.text.length > 0)
    {
        self->_siteForEdit.siteUrl = self->_urlTextField.text;
        self->_siteForEdit.site = self->_siteTextField.text;
        self->_siteForEdit.username = self->_usernameTextField.text;
        self->_siteForEdit.password = self->_passwordTextField.text;
        
        [ self authenticateAndSaveSite: self->_siteForEdit ];
    }
    else
    {
        [ sc_ErrorHelper showError: NSLocalizedString(@"Please enter username and password.", nil) ];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return _loggedIn;
}

-(BOOL)validateUrl: (NSString *)url
{
    if (url.length == 0)
    {
        return NO;
    }
    
    NSURL* tmpUrl = [NSURL URLWithString:url];
    return !(tmpUrl == NULL);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 80.f;
    }
    return 0.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        if(_footerView == nil)
        {
            _footerView  = [[UIView alloc] init];
            
            CGFloat padding = 10.f;
            CGFloat fontSize = 18.f;
            CGFloat width = 136.f;
            
            if (_appDataObject.isIpad)
            {
                padding = 45.f;
                fontSize = 24.f;
                width = 260.f;
            }
   
            sc_GradientButton *button = [sc_GradientButton buttonWithType:UIButtonTypeCustom];
            [(sc_GradientButton*) button setButtonWithStyle:CUSTOMBUTTONTYPE_IMPORTANT];
            [button setFrame:CGRectMake(tableView.frame.size.width- padding - width, 20.f, width, 45.f)];
            [button setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
            
            [ button addTarget: self
                        action: @selector(save:)
              forControlEvents: UIControlEventTouchUpInside ];
            
            [_footerView addSubview:button];
        }
    }
    
    return _footerView;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"New site", nil);
}

@end

