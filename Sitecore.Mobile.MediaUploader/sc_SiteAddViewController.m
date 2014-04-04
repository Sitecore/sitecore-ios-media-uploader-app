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

static const float slideDistance = 40.f;
static const float slideDuration = 0.3f;

@interface sc_SiteAddViewController ()
@property bool isRaised;
@property bool loggedIn;
@property UIView* loginFooterView;
@property sc_ActivityIndicator * activityIndicator;
@property UIView* footerView;
@end

@implementation sc_SiteAddViewController

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{   
    return NSLocalizedString(@"New site", nil);
}

- (void)initializeActivityIndicator
{
    _activityIndicator = [[sc_ActivityIndicator alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_activityIndicator];
}

-(IBAction)slideFrameUp
{
    if (_isRaised)
    {
        return;
    }
    [self slideFrame:YES];
    _isRaised = YES;
}

-(IBAction) slideFrameDown
{
    if (!_isRaised)
    {
        return;
    }
    
    [self slideFrame:NO];
    _isRaised = NO;
}

-(void)slideFrame:(BOOL)up
{
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: slideDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0.f, (up ? -slideDistance : slideDistance));
    [UIView commitAnimations];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //Localize UI
    self.navigationItem.title       = NSLocalizedString(self.navigationItem.title, nil);
    _passwordTextField.placeholder  = NSLocalizedString(_passwordTextField.placeholder, nil);
    _usernameTextField.placeholder  = NSLocalizedString(_usernameTextField.placeholder, nil);
    _urlTextField.placeholder       = NSLocalizedString(_urlTextField.placeholder, nil);
    _siteTextField.placeholder      = NSLocalizedString(_siteTextField.placeholder, nil);
    _cancelButton.title             = NSLocalizedString(_cancelButton.title, nil);
    
    [self initializeActivityIndicator];
    
    _appDataObject = [sc_GlobalDataObject getAppDataObject];
    
    _usernameTextField.delegate = self;
    _passwordTextField.delegate = self;
    _urlTextField.delegate = self;
    
    self.navigationItem.hidesBackButton = YES;
    _saveButton.target = self;
    _saveButton.action = @selector(save:);
    _cancelButton.target = self;
    _cancelButton.action = @selector(cancel:);
    
    
    if (!_appDataObject.isOnline)
    {
        _saveButton.enabled = NO;
    }
    
    _loggedIn = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear: animated ];
    
    [ self configureView ];
}

-(void)configureView
{
    _urlTextField.text  = @"";
    _siteTextField.text = [ sc_Site siteDefaultValue ];
    _usernameTextField.text = @"";
    _passwordTextField.text = @"";
    
#if DEBUG
    _urlTextField.text  = @"https://scmobileteam.sitecoretest.net";
    _siteTextField.text = @"sitecore/shell";
    _usernameTextField.text = @"admin";
    _passwordTextField.text = @"b";
#endif
}

-(void)authenticateAndSaveSite:(sc_Site *)site
{
    __block sc_Site *tmpSite = site;
    
    SCApiContext *context = [ sc_ItemHelper getContext: tmpSite ];
    
    SCAsyncOp asyncOp = [ context credentialsCheckerForSite: site.site ];
    
    [_activityIndicator showWithLabel:NSLocalizedString(@"Authenticating", nil)];
    
    asyncOp(^(id result, NSError *error)
    {
        [_activityIndicator hide];
        if ( !error )
        {
            //@igk removed according to Gabe request
//            if ( [ _appDataObject isSameSiteExist: tmpSite ] )
//            {
//                [ sc_ErrorHelper showError: NSLocalizedString( @"SITE_EXISTS_ERROR", nil ) ];
//            }
//            else
            {
                self->_site = [ tmpSite copy ];

                [_appDataObject addSite:self->_site];
                [_appDataObject saveSites];
                
                _loggedIn = YES;
                                    
                sc_SiteEditViewController * siteEditViewController = (sc_SiteEditViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"SiteEdit" ];
                [ siteEditViewController setSite:_site isNew: YES ];
                
                [ self.navigationController pushViewController: siteEditViewController
                                                      animated: YES];
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
        sc_Site *site = [[ sc_Site alloc ] initWithSiteUrl: self->_urlTextField.text
                                                      site: self->_siteTextField.text
                        uploadFolderPathInsideMediaLibrary: @""
                                            uploadFolderId: @""
                                                  username: self->_usernameTextField.text
                                                  password: self->_passwordTextField.text
                                         selectedForBrowse: NO
                                         selectedForUpdate: YES ];
        
        [ self authenticateAndSaveSite: site ];
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
            [button setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
            
            [ button addTarget: self
                        action: @selector(save:)
              forControlEvents: UIControlEventTouchUpInside ];
            
            [_footerView addSubview:button];
        }
    }
    
    return _footerView;
}


@end

