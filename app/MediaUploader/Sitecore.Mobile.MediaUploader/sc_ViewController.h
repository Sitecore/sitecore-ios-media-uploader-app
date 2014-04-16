//
//  sc_ViewController.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 6/2/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sc_ReloadableViewProtocol.h"

@class sc_GradientButton;

@interface sc_ViewController : UIViewController <sc_ReloadableViewProtocol>
@property (nonatomic) IBOutlet UILabel* messageLabel;
@property (nonatomic) IBOutlet sc_GradientButton* browseButton;
@property (nonatomic) IBOutlet sc_GradientButton* pendingButton;
@property (nonatomic) IBOutlet sc_GradientButton* uploadButton;
@property (nonatomic) IBOutlet UIBarButtonItem* settingsButton;
@property (nonatomic) IBOutlet UIView* pendingView;
@property (nonatomic) IBOutlet UILabel* pendingCounterLabel;

@end
