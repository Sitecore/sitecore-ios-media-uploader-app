//
//  sc_BaseTheme.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by Igor on 09/01/14.
//  Copyright (c) 2014 Sitecore. All rights reserved.
//

#import "sc_BaseTheme.h"

@implementation sc_BaseTheme

-(UIColor*)naviagtionBarBackgroundColor
{
    return [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.0f];
}

-(UIColor*)naviagtionBarTintColor
{
    return [UIColor colorWithRed:0.0f green:0.47f blue:1.0f alpha:1.0f];
}

-(UIColor*)normalRowBackgroundColor
{
    return [UIColor whiteColor];
}

-(UIColor*)uploadedRowBackgroundColor
{
    return [UIColor whiteColor];
}

-(UIColor*)errorRowBackgroundColor
{
    return [UIColor whiteColor];
}

-(UIColor*)errorLabelColor
{
    return [UIColor colorWithRed:0.8f green:0.225f blue:0.225f alpha:1.0f];
}

-(UIColor*)labelBackgroundColor
{
    return [UIColor colorWithRed:1.0f green:1.0f  blue:1.0f  alpha:1.0f];
}

-(UIColor*)transparentLabelBackgroundColor
{
    return [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f];
}

-(UIColor*)disableSiteBackgroundColor
{
    return [ UIColor colorWithWhite:0.9f alpha:1.f ];
}

-(UIImage *)uploadDoneIconImage
{
    return [UIImage imageNamed:@"Green-Tick"];
}

-(UIImage *)uploadErrorIconImage
{
    return [UIImage imageNamed:@"Red-Warning"];
}

-(UIImage *)uploadCanceledIconImage
{
    return [UIImage imageNamed:@"Red-Warning"];
}

-(UIImage *)uploadReadyIconImage
{
    return nil;
}

@end
