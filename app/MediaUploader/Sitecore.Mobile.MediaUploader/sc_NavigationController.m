//
//  sc_NavigationController.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 8/24/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_NavigationController.h"
#import "sc_BaseTheme.h"

@interface sc_NavigationController ()

@end

@implementation sc_NavigationController
{
    sc_BaseTheme *_theme;
}
-(void)viewDidLoad
{
    [ super viewDidLoad ];

    self->_theme = [ sc_BaseTheme new ];
    
    if ( [ [ [ UIDevice currentDevice ] systemVersion ] intValue ] >= 7 )
    {
        [ self.navigationBar setBackgroundImage: [ UIImage imageNamed:@"navigationBarBg.png" ] forBarMetrics:UIBarMetricsDefault ];
        [ self.navigationBar setBackgroundColor: [ self->_theme naviagtionBarBackgroundColor ] ];
        [ self.navigationBar setTintColor: [ self->_theme naviagtionBarTintColor ] ];
        [ self.navigationBar setBarStyle: UIBarStyleDefault ];
    }

}

@end
