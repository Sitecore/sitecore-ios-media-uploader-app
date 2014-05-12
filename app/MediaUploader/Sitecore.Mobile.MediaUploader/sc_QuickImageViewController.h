#import <UIKit/UIKit.h>

@class SCApiSession;

@class NSMutableArray;
@class UICollectionView;


@interface sc_QuickImageViewController : UIViewController
<
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UISearchBarDelegate
>

@property (nonatomic, retain) NSMutableArray*  items;
@property (nonatomic) NSUInteger selectedImage;
@property (nonatomic) IBOutlet UICollectionView* collectionView;
@property (nonatomic, strong) SCApiSession* session;

@end
