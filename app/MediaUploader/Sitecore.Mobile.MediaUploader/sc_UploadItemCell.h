#import <UIKit/UIKit.h>

@class sc_BaseTheme;

@interface sc_UploadItemCell : UITableViewCell

@property ( nonatomic ) IBOutlet UIImageView* cellImageView;
@property ( nonatomic ) IBOutlet UILabel* siteLabel;
@property ( nonatomic ) IBOutlet UILabel* folderLabel;
@property ( nonatomic ) IBOutlet UIActivityIndicatorView* activityView;

-(void)setCellStyleForUploadStatus:(sc_UploadItemStatus*)status withTheme:(sc_BaseTheme*)theme;

@end
