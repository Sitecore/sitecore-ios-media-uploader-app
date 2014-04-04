//
//  sc_BaseTheme.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by Igor on 09/01/14.
//  Copyright (c) 2014 Sitecore. All rights reserved.
//

#import "sc_BaseTheme.h"

@implementation sc_BaseTheme

-(UIColor *)naviagtionBarBackgroundColor
{
    return [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
}

-(UIColor *)naviagtionBarTintColor
{
    return [UIColor colorWithRed:0.0 green:0.47 blue:1 alpha:1.0];
}

-(UIColor *)normalRowBackgroundColor
{
    return [UIColor whiteColor];
}

-(UIColor *)uploadedRowBackgroundColor
{
    return [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];
}

-(UIColor *)errorRowBackgroundColor
{
    return [UIColor colorWithRed:0.8 green:0.225 blue:0.225 alpha:1.0];
}

-(UIColor *)errorLabelColor
{
    return [UIColor colorWithRed:0.8 green:0.225 blue:0.225 alpha:1.0];
}

-(UIColor *)labelBackgroundColor
{
    return [UIColor colorWithRed:1.0 green:1.0  blue:1.0  alpha:1.0];
}

-(UIColor *)transparentLabelBackgroundColor
{
    return [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
}

-(UIColor *)disableSiteBackgroundColor
{
    return [ UIColor colorWithWhite:0.9f alpha:1.f ];
}

@end
