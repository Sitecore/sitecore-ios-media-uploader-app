//
//  sc_BrowseCell.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by Igor on 03/12/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sc_ItemHelper.h"

@interface sc_BrowseCell : UICollectionViewCell

@property( nonatomic ) IBOutlet SCImageView *cellImageView;
@property( nonatomic ) IBOutlet UILabel *label;
@property( nonatomic ) IBOutlet UIActivityIndicatorView *cellActivityView;

-(void)setCellType:(sc_CellType)cellType item:(SCItem *)item context:(SCApiContext *)context;

@end
