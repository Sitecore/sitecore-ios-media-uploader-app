//
//  sc_ActivityIndicator.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by Steve Jennings on 7/24/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sc_ActivityIndicator : UIView

-(id) initWithFrame:(CGRect)frame;
-(void) showWithLabel: (NSString *)label afterDelay: (float) wait;
-(void) showWithLabel: (NSString *)label;
-(void) hide;

@end
