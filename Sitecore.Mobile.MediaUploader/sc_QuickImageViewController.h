//
//  sc_QuickImageViewController.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by Steve Jennings on 6/9/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sc_QuickImageViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>

@property (nonatomic) IBOutlet SCImageView *imageView;
@property (nonatomic, retain) NSMutableArray * items;
@property (nonatomic) int selectedImage;
@property (nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) SCApiSession *session;

@end
