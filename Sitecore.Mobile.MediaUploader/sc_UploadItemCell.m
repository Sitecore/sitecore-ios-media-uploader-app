//
//  sc_UploadItemCell.m
//  Sitecore.Mobile.MediaUploader
//
//  Created by Igor on 13/12/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "sc_UploadItemCell.h"
#import "sc_Constants.h"
#import "sc_UploadItemStatus.h"
#import "sc_BaseTheme.h"

@implementation sc_UploadItemCell

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        if ( !self.backgroundView )
        {
            // hack to use .backgroundView property for iOS6 plain table cells
            UIView * backView = [ UIView new ];
            backView.frame = self.frame;
            [ self insertSubview: backView atIndex: 0 ];
            self.backgroundView = backView;
        }
    }
    
    return self;
}


-(void)setCellStyleForUploadStatus:(sc_UploadItemStatus *)status withTheme:(sc_BaseTheme *)theme
{
    UIColor *backgroundColor;
    
    switch ( status.statusId )
    {
        case inProgressStatus:
            [ self.activityView startAnimating ];
            backgroundColor = [ theme normalRowBackgroundColor ];
            self.siteLabel.textColor = [ UIColor blackColor ];
            self.folderLabel.textColor = [ UIColor blackColor ];
            break;
        case doneStatus:
            self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whiteCheckmark.png"]];
            [ self.activityView stopAnimating ];
            backgroundColor = [ theme uploadedRowBackgroundColor ];
            break;
        case errorStatus:
            self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
            [ self.activityView stopAnimating ];
            backgroundColor = [ theme errorRowBackgroundColor ];
            break;
        case canceledStatus:
            self.siteLabel.textColor = [ UIColor whiteColor ];
            self.folderLabel.textColor = [ UIColor whiteColor ];
            self.folderLabel.text = NSLocalizedString(@"Cancelled", nil);
            self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.png"]];
            [ self.activityView stopAnimating ];
            backgroundColor = [ theme errorRowBackgroundColor ];
            break;
        default:
            break;
    }
    
    self.backgroundView.backgroundColor = backgroundColor;
}

@end
