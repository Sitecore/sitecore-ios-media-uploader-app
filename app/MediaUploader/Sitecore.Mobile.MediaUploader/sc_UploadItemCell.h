#import <UIKit/UIKit.h>

@class sc_BaseTheme;

@interface sc_UploadItemCell : UITableViewCell

@property ( nonatomic ) IBOutlet UIImageView* cellImageView;
@property ( nonatomic ) IBOutlet UILabel* nameLabel;
@property ( nonatomic ) IBOutlet UILabel* siteLabel;
@property ( nonatomic ) IBOutlet UILabel* folderLabel;
@property ( nonatomic ) IBOutlet UIActivityIndicatorView* activityView;

-(void)setCellStyleForUploadStatus:(MUUploadItemStatus*)status withTheme:(sc_BaseTheme*)theme;

@end
