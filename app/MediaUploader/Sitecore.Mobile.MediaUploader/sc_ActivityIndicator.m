//
//  sc_ActivityIndicator.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by Steve Jennings on 7/24/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_ActivityIndicator.h"

@interface sc_ActivityIndicator()
@end

@implementation sc_ActivityIndicator
{
    UIActivityIndicatorView *_activityView;
    UILabel *_loadingLabel;
}

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake((frame.size.width - 170) /2, (frame.size.height- 170) /2, 170, 170)];
    if( !self ) return nil;
    
    self.hidden=YES;
    self.backgroundColor = [ UIColor colorWithRed:0 green:0 blue:0 alpha:0.5 ];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 10.0;
    
    self->_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self->_activityView.frame = CGRectMake(65, 40, self->_activityView.bounds.size.width, self->_activityView.bounds.size.height);
    [ self addSubview: self->_activityView ];
    
    self->_loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    self->_loadingLabel.backgroundColor = [UIColor clearColor];
    self->_loadingLabel.textColor = [UIColor whiteColor];
    self->_loadingLabel.adjustsFontSizeToFitWidth = YES;
    self->_loadingLabel.textAlignment = NSTextAlignmentCenter;
    [ self addSubview: self->_loadingLabel ];
    [ self->_activityView startAnimating ];
    
    return self;
}

-(void) showWithLabel: (NSString *)label
{
    [ self showWithLabel: label
              afterDelay: 0 ];
}

-(void) showWithLabel: (NSString *)label afterDelay: (float) wait
{
    [self cancelAllRequests];
    self->_loadingLabel.text = label;
    [ self performSelector: @selector(showActivityView)
                withObject: nil
                afterDelay: wait ];
}

-(void) showActivityView
{
    self.hidden = NO;
}

-(void) hide
{
    [self cancelAllRequests];
    self.hidden = YES;
}

-(void) cancelAllRequests
{
    [ NSObject cancelPreviousPerformRequestsWithTarget: self ];
}

@end