//
//  sc_ViewController.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/2/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_ViewController.h"
#import "sc_GlobalDataObject.h"
#import "sc_AppDelegateProtocol.h"
#import"sc_Upload2ViewController.h"
#import "sc_GradientButton.h"

@interface sc_ViewController ()

@property ( nonatomic ) sc_GlobalDataObject* appDataObject;

@end

@implementation sc_ViewController

-(void)viewDidDisappear
{
    [ [NSNotificationCenter defaultCenter] removeObserver: self
                                                     name: UIApplicationWillEnterForegroundNotification
                                                   object: nil ];
}

-(void)reload
{
    [self enableApplication];
}

-(NSNumberFormatter*)numberFormatterForUploadCount
{
    static NSNumberFormatter* result = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^void()
    {
        NSNumberFormatter* uploadCountFormatter = [ NSNumberFormatter new ];
        {
            [ uploadCountFormatter setNumberStyle: NSNumberFormatterDecimalStyle ];
            [ uploadCountFormatter setAllowsFloats: NO ];
        }

        result = uploadCountFormatter;
    } );
    
    
    return result;
}

-(void)enableApplication
{
    _messageLabel.text = @"";
    _pendingButton.enabled = NO;
    _pendingView.hidden = YES;
    
    if ( !_appDataObject.isOnline )
    {
        _browseButton.enabled = NO;
        _settingsButton.enabled = NO;
        _messageLabel.text = NSLocalizedString(@"Please check your internet connection.", nil);
        
        if ( ![ _appDataObject.sitesManager atLeastOneSiteExists ] )
        {
            _uploadButton.enabled = NO;
        }
        return;
    }
    
    _uploadButton.enabled = YES;
    _settingsButton.enabled = YES;
    
    if ( ![ _appDataObject.sitesManager atLeastOneSiteExists ] )
    {
        _browseButton.enabled = NO;
        _uploadButton.enabled = NO;
        _messageLabel.text = NSLocalizedString(@"Please set up at least one upload site.", nil);
    }
    else
    {
        _browseButton.enabled = YES;
        _uploadButton.enabled = YES;
        
        if ( _appDataObject.uploadItemsManager.uploadCount > 0 && _appDataObject.isOnline )
        {
            //_pendingView.hidden = NO;
            _pendingButton.enabled = YES;
            _pendingView.hidden = NO;
            
            NSNumberFormatter* uploadCountFormatter = [ self numberFormatterForUploadCount ];
            NSUInteger rawUploadCount = self->_appDataObject.uploadItemsManager.uploadCount;

            NSString* result = [ uploadCountFormatter stringFromNumber: @(rawUploadCount) ];
            self->_pendingCounterLabel.text = [ NSString stringWithFormat: @"%@", result ];
        }
    }
}

-(void)viewDidLoad
{
    [ super viewDidLoad ];
    
    _appDataObject = [ sc_GlobalDataObject getAppDataObject ];
    
    [ [NSNotificationCenter defaultCenter] addObserver: self
                                              selector: @selector( enableApplication )
                                                  name: UIApplicationWillEnterForegroundNotification
                                                object: nil ];
    
    [ _uploadButton setButtonWithStyle: CUSTOMBUTTONTYPE_NORMAL ];
    [ _browseButton setButtonWithStyle: CUSTOMBUTTONTYPE_NORMAL ];
    [ _pendingButton setButtonWithStyle: CUSTOMBUTTONTYPE_NORMAL ];
    
    //Localize buttons
    [ _uploadButton setTitle: NSLocalizedString(@"Upload", nil) forState: UIControlStateNormal ];
    [ _browseButton setTitle: NSLocalizedString(@"Browse", nil) forState: UIControlStateNormal ];
    [ _pendingButton setTitle: NSLocalizedString(@"Pending", nil) forState: UIControlStateNormal ];
    
    if ( _appDataObject.IOS >= 7 )
    {
        [ _settingsButton setImage: [UIImage imageNamed:@"settings.png"] ];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [ self enableApplication ];
}

@end
