#import "sc_UploadItemCell.h"
#import "sc_BaseTheme.h"

@implementation sc_UploadItemCell

-(id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        if ( !self.backgroundView )
        {
            // hack to use .backgroundView property for iOS6 plain table cells
            UIView*  backView = [ UIView new ];
            backView.frame = self.frame;
            [ self insertSubview: backView atIndex: 0 ];
            self.backgroundView = backView;
        }
    }
    
    return self;
}


-(void)setCellStyleForUploadStatus:(MUUploadItemStatus*)status withTheme:(sc_BaseTheme*)theme
{
    UIImage* image;
    
    self.siteLabel.textColor = [ UIColor blackColor ];
    self.folderLabel.textColor = [ UIColor blackColor ];
    self.nameLabel.textColor = [ UIColor blackColor ];
    
    switch ( status.statusId )
    {
        case READY_FOR_UPLOAD:
            [ self.activityView stopAnimating ];
            image = [ theme uploadReadyIconImage ];
            break;
        case UPLOAD_IN_PROGRESS:
            [ self.activityView startAnimating ];
            break;
        case UPLOAD_DONE:
            image = [ theme uploadDoneIconImage ];
            [ self.activityView stopAnimating ];
            break;
        case UPLOAD_ERROR:
            image = [ theme uploadErrorIconImage ];
            [ self.activityView stopAnimating ];
            break;
        case DATA_IS_NOT_AVAILABLE:
            image = [ theme uploadErrorIconImage ];
            [ self.activityView stopAnimating ];
            break;
        case UPLOAD_CANCELED:
            self.folderLabel.text = NSLocalizedString(@"Cancelled", nil);
            image = [ theme uploadCanceledIconImage ];
            [ self.activityView stopAnimating ];
            break;
        default:
            break;
    }
    self.accessoryView = [ [UIImageView alloc] initWithImage: image ];
    self.accessoryView.contentMode = UIViewContentModeCenter;
}

@end
