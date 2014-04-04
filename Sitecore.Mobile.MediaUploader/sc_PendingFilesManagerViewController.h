//
//  sc_PendingFilesManagerViewController.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by andrea bellagamba on 7/7/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sc_GlobalDataObject.h"
#import "sc_CleaningProtocol.h"

@class sc_GradientButton;

@interface sc_PendingFilesManagerViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, sc_CleaningProtocol >

@property (nonatomic) IBOutlet sc_GradientButton *uploadButton;
@property (nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) IBOutlet UIButton *removeButton;
@property (nonatomic) IBOutlet UIImageView *imageView;
@property sc_GlobalDataObject *appDataObject;

@end

