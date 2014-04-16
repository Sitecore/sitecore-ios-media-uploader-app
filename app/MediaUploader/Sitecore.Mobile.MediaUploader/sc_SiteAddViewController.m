//
//  sc_SiteEditViewController.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 7/26/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_SiteAddViewController.h"
#import "sc_ListBrowserViewController.h"
#import "sc_GlobalDataObject.h"
#import "sc_AppDelegateProtocol.h"
#import "sc_SettingsViewController.h"
#import "sc_GradientButton.h"
#import "sc_Constants.h"
#import "sc_ActivityIndicator.h"
#import "sc_ErrorHelper.h"
#import "sc_ItemHelper.h"
#import "sc_ButtonsBuilder.h"
#import "SCSite+Trackable.h"

@interface sc_SiteAddViewController ()

@property (nonatomic) BOOL loggedIn;
@property (nonatomic) UIView* loginFooterView;
@property (nonatomic) sc_ActivityIndicator * activityIndicator;
@property (nonatomic) UIView* footerView;
@property (nonatomic) IBOutlet UISegmentedControl *protocolSelector;
@end

static NSString *HTTPS_PROTOCOL_STRING = @"https://";
static NSString *HTTP_PROTOCOL_STRING = @"http://";

@implementation sc_SiteAddViewController
{
    sc_GlobalDataObject *_appDataObject;
    UIBarButtonItem *_saveButton;
    
    SCSite *_siteForEdit;
    BOOL editModeEnabled;
    
    sc_ButtonsBuilder *buttonsBuilder;
    sc_GradientButton *nextButton;
}

-(void)viewDidLoad
{
    [ super viewDidLoad ];
    
    [ self configureView ];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    buttonsBuilder = [ sc_ButtonsBuilder new ];
    
    self->_siteForEdit = [ SCSite emptySite ];
    editModeEnabled = NO;
    
    [ self localizeUI ];
    
    _appDataObject = [sc_GlobalDataObject getAppDataObject];
    
    self.navigationItem.hidesBackButton = YES;
    
    _cancelButton.target = self;
    _cancelButton.action = @selector(cancel:);
    
    [ self initializeActivityIndicator ];
}

- (void)initializeActivityIndicator
{
    _activityIndicator = [[sc_ActivityIndicator alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_activityIndicator];
}

-(void)setSiteForEdit:(SCSite *)site
{
    self->_siteForEdit = site;
    
    //TODO: @igk refactor this
    if ([ site.siteProtocol isEqualToString:HTTPS_PROTOCOL_STRING ])
    {
        [ self.protocolSelector setSelectedSegmentIndex: 1 ];
    }
    else
    {
        [ self.protocolSelector setSelectedSegmentIndex: 0 ];
    }
    
    editModeEnabled = YES;
    
    [ self configureView ];
}

-(void)localizeUI
{
    self.navigationItem.title      = NSLocalizedString(self.navigationItem.title     , nil);
    _passwordTextField.placeholder = NSLocalizedString(_passwordTextField.placeholder, nil);
    _usernameTextField.placeholder = NSLocalizedString(_usernameTextField.placeholder, nil);
    _urlTextField.placeholder      = NSLocalizedString(_urlTextField.placeholder     , nil);
    _siteTextField.placeholder     = NSLocalizedString(_siteTextField.placeholder    , nil);
    _cancelButton.title            = NSLocalizedString(_cancelButton.title           , nil);
}

-(void)configureView
{
    _urlTextField.text      = self->_siteForEdit.siteUrl;
    _siteTextField.text     = self->_siteForEdit.site;
    _usernameTextField.text = self->_siteForEdit.username;
    _passwordTextField.text = self->_siteForEdit.password;
}

-(void)saveSiteWithUploadFolder:(NSString *)uploadFolder
{
    [ self fillSiteWithData: self->_siteForEdit ];
    self->_siteForEdit.uploadFolderPathInsideMediaLibrary = uploadFolder;
    
    NSError *error;
    if ( editModeEnabled )
    {
        [ self->_appDataObject.sitesManager saveSites ];
    }
    else
    {
        [ self->_appDataObject.sitesManager addSite: self->_siteForEdit
                                              error: &error ];
    }

    if ( error )
    {
        [sc_ErrorHelper showError:NSLocalizedString(error.localizedDescription, nil)];
    }
    else
    {
        [ self popToSettingsVC ];
    }

}

-(void)popToSettingsVC
{
    NSUInteger upStepsCount = 3;
    NSUInteger vcCount = [ self.navigationController.viewControllers count ];
    
    if ( upStepsCount > vcCount )
    {
        [ self.navigationController popToRootViewControllerAnimated: YES ];
        return;
    }
    
    UIViewController *vcToPop = self.navigationController.viewControllers[ vcCount-upStepsCount ];
    [ self.navigationController popToViewController: vcToPop
                                           animated: YES ];
}

-(void)authenticateAndSaveSite:(SCSite *)site
{
    __block SCSite *tmpSite = site;
    
    SCApiSession *session = [ sc_ItemHelper getContext: tmpSite ];
    
    SCAsyncOp asyncOp = [ session checkCredentialsOperationForSite: site.site ];
    
    [ _activityIndicator showWithLabel: NSLocalizedString(@"Authenticating", nil) ];
    
    self->nextButton.enabled = NO;
    
    asyncOp(^( id result, NSError *error )
    {
        id<MUSessionTracker> sessionTracker =
        [ MUEventsTrackerFactory sessionTrackerForMediaUploader ];

        [ self->_activityIndicator hide ];
        if ( !error )
        {
            [ sessionTracker didLoginWithSite: site ];
            


            id rawSiteEditViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"ListItemsBrowser" ];
            sc_ListBrowserViewController * siteEditViewController = (sc_ListBrowserViewController *)rawSiteEditViewController;
            
            SCUPloadFolderReceived didSelectUploadFolderCallback = ^void(NSString *folder)
            {
                [ self saveSiteWithUploadFolder: folder ];
            };
            
            
            [ siteEditViewController chooseUploaderFolderForSite: tmpSite
                                                     witCallback: didSelectUploadFolderCallback ];
            
            [ self.navigationController pushViewController: siteEditViewController
                                                  animated: YES ];

        }
        else
        {
            
            [ sessionTracker didLoginFailedForSite: site
                                         withError: error ];
            
            [ sc_ErrorHelper showError: NSLocalizedString(@"Authentication failure.", nil) ];
        }
        
        self->nextButton.enabled = YES;
    });
}

-(IBAction)cancel:(id)sender
{
    [ self.navigationController popViewControllerAnimated: YES ];
}


-(void)save:(id)sender
{
    BOOL requiredFieldsFilled =     _usernameTextField.text.length > 0
    &&  _passwordTextField.text.length > 0
    &&  _urlTextField.text.length > 0;
    
    if ( requiredFieldsFilled )
    {
        SCSite *fakeSite = [ SCSite emptySite ];
        [ self fillSiteWithData: fakeSite ];
        [ self authenticateAndSaveSite: fakeSite ];
    }
    else
    {
        [ sc_ErrorHelper showError: NSLocalizedString(@"Please enter username and password.", nil) ];
    }
}

-(void)fillSiteWithData:(SCSite *)siteToFill
{
     NSString *protocol;
    
    if ( self.protocolSelector.selectedSegmentIndex == 0 )
    {
        protocol = HTTP_PROTOCOL_STRING;
    }
    else
    {
        protocol = HTTPS_PROTOCOL_STRING;
    }

   siteToFill.siteProtocol = protocol;
   siteToFill.siteUrl = self->_urlTextField.text;
   siteToFill.site = self->_siteTextField.text;
   siteToFill.username = self->_usernameTextField.text;
   siteToFill.password = self->_passwordTextField.text;
}

-(void)remove:(id)sender
{
    id<MUSessionTracker> sessionTracker =
    [ MUEventsTrackerFactory sessionTrackerForMediaUploader ];
    [ sessionTracker didLogoutFromSite: self->_siteForEdit ];
    
    
    [ self->_appDataObject.sitesManager removeSite: self->_siteForEdit ];
    [ self.navigationController popViewControllerAnimated: YES ];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
            
            CGFloat padding = 20.f;
            CGFloat buttonWidth = (tableView.frame.size.width - 3*padding)/2.f;
            CGFloat buttonHeight = 45.f;
            
            CGRect firstButtonFrame = CGRectMake(padding, padding, buttonWidth, buttonHeight);
            CGRect secondButtonFrame = CGRectMake(2*padding + buttonWidth, padding, buttonWidth, buttonHeight);
            
            sc_GradientButton *secondButton = [ buttonsBuilder getButtonWithTitle: @"Next"
                                                                            style:CUSTOMBUTTONTYPE_IMPORTANT
                                                                           target: self
                                                                         selector: @selector(save:) ];
            [ secondButton setFrame: secondButtonFrame ];
            [ _footerView addSubview:secondButton ];
            self->nextButton = secondButton;
            
            sc_GradientButton *firstButton = [ buttonsBuilder getButtonWithTitle: @"Delete"
                                                                           style: CUSTOMBUTTONTYPE_DANGEROUS
                                                                          target: self
                                                                        selector: @selector(remove:) ];
            [ firstButton setFrame: firstButtonFrame ];
            [ _footerView addSubview:firstButton ];
        }
    }
    
    return _footerView;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"New site", nil);
}

@end

