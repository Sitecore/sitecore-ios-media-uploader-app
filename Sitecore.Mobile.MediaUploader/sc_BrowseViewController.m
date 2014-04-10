#import "sc_BrowseViewController.h"
#import "sc_Site.h"
#import "sc_GlobalDataObject.h"
#import "sc_ItemHelper.h"
#import "sc_GradientButton.h"
#import "sc_BrowseViewCellFactory.h"
#import "sc_LevelUpGridCell.h"
#import "sc_QuickImageViewController.h"
#import "sc_GridBrowserRequestBuilder.h"

@interface sc_BrowseViewController ()<SCItemsBrowserDelegate>

@property (nonatomic, strong) IBOutlet sc_BrowseViewCellFactory *cellFactory;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingProgress;
@property (weak, nonatomic) IBOutlet UITextView *itemPathTextView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *itemsBrowserGridLayout;

@property (nonatomic) IBOutlet UILabel *singleSiteLabel;
@property (nonatomic) IBOutlet sc_GradientButton *siteButton;
@property (nonatomic) IBOutlet UILabel *siteLabel;
@property (nonatomic) IBOutlet UIView *singleSiteBgView;

-(IBAction)forceRefresh:(id)selector;

@end

@implementation sc_BrowseViewController
{
    SCApiSession* _legacyApiSession;
    SCExtendedApiSession* _apiSession;
    sc_Site *_siteForBrowse;
    
    sc_GlobalDataObject *_appDataObject;
    sc_GridBrowserRequestBuilder *_requestBuilder;
    
    BOOL browserMustBeReloaded;
}

-(void)viewDidLoad
{
    [ super viewDidLoad ];
    self->_appDataObject = [ sc_GlobalDataObject getAppDataObject ];
    [ self setupLayout  ];
    
    NSArray *templatesList = @[@"Image", @"Jpeg", @"Media folder"];
    self->_requestBuilder = [ [ sc_GridBrowserRequestBuilder alloc ] initWithTemplateNames: templatesList ];
    self.cellFactory.itemsBrowserController.nextLevelRequestBuilder = self->_requestBuilder;
    browserMustBeReloaded = YES;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear: animated ];
    
    if ( browserMustBeReloaded )
    {
        browserMustBeReloaded = NO;
        [ self reloadBrowserWithNewSite ];
    }
}

-(void)reloadBrowserWithNewSite
{
    self->_siteForBrowse = self->_appDataObject.sitesManager.siteForBrowse;
    
    self->_legacyApiSession = [ sc_ItemHelper getContext:self->_siteForBrowse ];
    
    self->_apiSession = self->_legacyApiSession.extendedApiSession;
    
    self.cellFactory.itemsBrowserController.apiSession = self->_apiSession;
    
    NSString *rootFolderPath = [ sc_Site mediaLibraryDefaultPath ];
    
    SCExtendedAsyncOp rootItemLoader =
    [ self->_apiSession readItemOperationForItemPath: rootFolderPath
                                          itemSource: nil ];
    
    [ self startLoading ];
    __weak sc_BrowseViewController* weakSelf = self;
    rootItemLoader( nil, nil, ^( SCItem* rootItem, NSError* blockError )
                   {
                       [ weakSelf endLoading ];
                       
                       if ( nil == rootItem )
                       {
                           [ weakSelf didFailLoadingRootItemWithError: blockError ];
                       }
                       else
                       {
                           [ weakSelf didLoadRootItem: rootItem ];
                       }
                   } );
}

-(void)setupLayout
{
    self.itemsBrowserGridLayout.itemSize = CGSizeMake( 100, 100 );
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"selectBrowse"])
    {
       browserMustBeReloaded = YES;
    }
}

#pragma mark -
#pragma mark Progress
-(void)startLoading
{
    self.loadingProgress.hidden = NO;
    [ self.loadingProgress startAnimating ];
}

-(void)endLoading
{
    [ self.loadingProgress stopAnimating ];
    self.loadingProgress.hidden = YES;
}

-(IBAction)forceRefresh:(id)selector
{
    [ self.cellFactory.itemsBrowserController forceRefreshData ];
}

-(void)didFailLoadingRootItemWithError:( NSError* )error
{
    [ sc_ErrorHelper showError: error.localizedDescription ];
    [ self endLoading ];
}

-(void)didLoadRootItem:( SCItem* )rootItem
{
    self.cellFactory.itemsBrowserController.rootItem = rootItem;
    
    [ self startLoading ];
    [ self.cellFactory.itemsBrowserController navigateToRootItem ];
}

-(void)showCannotReloadMessage
{
    [ sc_ErrorHelper showError: NSLocalizedString( @"ALERT_RELOAD_LEVEL_ERROR_MESSAGE", nil ) ];
    [ self endLoading ];
}

#pragma mark -
#pragma mark SCItemsBrowserDelegate
-(void)itemsBrowser:( id )sender
didReceiveLevelProgressNotification:( id )progressInfo
{
    [ self startLoading ];
}

-(void)itemsBrowser:( id )sender
levelLoadingFailedWithError:( NSError* )error
{
    [ sc_ErrorHelper showError: error.localizedDescription ];
    [ self endLoading ];
}

-(void)itemsBrowser:( id )sender
didLoadLevelForItem:( SCItem* )levelParentItem
{
    NSParameterAssert( nil != levelParentItem );
    
    [ self endLoading ];
    self.itemPathTextView.text = levelParentItem.path;
    
    
    // leaving this on the user's behalf
    NSIndexPath* top = [ NSIndexPath indexPathForRow: 0
                                           inSection: 0 ];
    
    UICollectionView* collectionView = self.cellFactory.itemsBrowserController.collectionView;
    [ collectionView scrollToItemAtIndexPath: top
                            atScrollPosition: UICollectionViewScrollPositionTop
                                    animated: NO ];
}

-(BOOL)itemsBrowser:( id )sender
shouldLoadLevelForItem:( SCItem* )levelParentItem
{
    if ( levelParentItem.isFolder || levelParentItem.hasChildren )
    {
        return YES;
    }
    else
    {
        sc_QuickImageViewController *quickImageViewController = (sc_QuickImageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"sc_QuickImageViewController"];
        quickImageViewController.items = [ self itemsForQuickViewControllerForLevelItem:levelParentItem ];
        quickImageViewController.selectedImage = [ quickImageViewController.items indexOfObject:levelParentItem ];
        quickImageViewController.session = self->_legacyApiSession;
        [self.navigationController pushViewController:quickImageViewController animated:YES];

    }
    
    return NO;
}

-(NSMutableArray *)itemsForQuickViewControllerForLevelItem:(SCItem *)levelItem
{
    NSArray * items = [ levelItem.parent.readChildren mutableCopy ];
    items = [ items sortedArrayUsingComparator: [ self sortResultComparatorForItemsBrowser:nil ] ];
    return [ items mutableCopy ];
}

-(NSComparator)sortResultComparatorForItemsBrowser:( id )sender
{
    return ^NSComparisonResult(SCItem *obj1, SCItem *obj2) {
        
        if ( ![obj1 isMemberOfClass:[SCItem class]] )
        {
            return NSOrderedAscending;
        }
        
        if ( ![obj2 isMemberOfClass:[SCItem class]] )
        {
            return NSOrderedDescending;
        }
        
        if ( obj1.isFolder && !obj2.isFolder)
        {
            return NSOrderedAscending;
        }
        
        if ( obj2.isFolder && !obj1.isFolder)
        {
            return NSOrderedDescending;
        }
        
        return [ obj1.displayName compare: obj2.displayName ];
        
    };
}


@end
