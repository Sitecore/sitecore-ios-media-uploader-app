//
//  sc_QuickImageViewController.h
//  Sitecore.Mobile.MediaUploader
//
//  Created by Steve Jennings on 6/9/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCImageView;
@class SCApiSession;

@class NSMutableArray;
@class UICollectionView;



@interface sc_QuickImageViewController : UIViewController
<
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UISearchBarDelegate
>

@property (nonatomic) IBOutlet SCImageView* imageView;
@property (nonatomic, retain) NSMutableArray*  items;
@property (nonatomic) NSUInteger selectedImage;
@property (nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) SCApiSession *session;


@end
