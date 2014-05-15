#import "sc_BrowseViewController.h"
#import "sc_GlobalDataObject.h"
#import "sc_ItemHelper.h"
#import "sc_GradientButton.h"
#import "sc_BrowseViewCellFactory.h"
#import "sc_QuickImageViewController.h"
#import "sc_GridBrowserRequestBuilder.h"


@interface sc_BrowseViewController ()<SCItemsBrowserDelegate>

// ???
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* loadingProgress;

@property (nonatomic, strong) IBOutlet sc_BrowseViewCellFactory* cellFactory;
@property (nonatomic, weak  ) IBOutlet UILabel* itemPathLabel;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout* itemsBrowserGridLayout;

@property (nonatomic, weak) IBOutlet sc_GradientButton* siteButton;
@property (nonatomic, weak) IBOutlet UILabel* siteLabel;
@property (nonatomic, weak) IBOutlet UIView* singleSiteBgView;
@property (nonatomic, weak) IBOutlet UICollectionView* browserGrid;

@property (nonatomic, strong) IBOutlet SCItemGridBrowser* gridBrowser;

-(IBAction)forceRefresh:(id)selector;

@end

@implementation sc_BrowseViewController
{
    SCApiSession* _legacyApiSession;
    SCExtendedApiSession* _apiSession;
    SCSite* _siteForBrowse;

    
    sc_GlobalDataObject* _appDataObject;
    sc_GridBrowserRequestBuilder* _requestBuilder;
    
    BOOL browserMustBeReloaded;
}

-(void)viewDidLoad
{
    [ super viewDidLoad ];
    self->_appDataObject = [ sc_GlobalDataObject getAppDataObject ];
    [ self resetSiteForBrowse ];
    [ self setupLayout  ];
    [ self checkSitesAvailability ];
    NSArray* templatesList = @[@"Image", @"Jpeg", @"Media folder", @"File"];
    self->_requestBuilder = [ [ sc_GridBrowserRequestBuilder alloc ] initWithTemplateNames: templatesList ];
    self.cellFactory.itemsBrowserController.nextLevelRequestBuilder = self->_requestBuilder;
    browserMustBeReloaded = YES;
    
}

-(void)checkSitesAvailability
{
    BOOL oneSiteAvailable = self->_appDataObject.sitesManager.sitesCount <= 1;
    if ( oneSiteAvailable )
    {
        [ self.singleSiteBgView removeFromSuperview ];
        CGRect newFrame;
        newFrame = self.itemPathLabel.frame;
        newFrame.origin.y = 0;
        self.itemPathLabel.frame = newFrame;
        
        CGFloat dY = newFrame.size.height;
        newFrame = self.browserGrid.frame;
        newFrame.origin.y = dY;
        newFrame.size.height = self.view.bounds.size.height - dY;
        self.browserGrid.frame = newFrame;
    }
}

-(void)resetSiteForBrowse
{
    SCSite* defaultSiteForBrowse = self->_appDataObject.sitesManager.siteForUpload;
    NSError* error;
    [ self->_appDataObject.sitesManager setSiteForBrowse: defaultSiteForBrowse
                                                   error: &error ];
    NSLog( @"resetSiteForBrowse error: %@", error );
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
    
    [ self.siteLabel setText: self->_siteForBrowse.siteUrl ];
    
    self->_legacyApiSession = [ sc_ItemHelper getContext: self->_siteForBrowse ];
    
    self->_apiSession = self->_legacyApiSession.extendedApiSession;
    
    self.cellFactory.itemsBrowserController.apiSession = self->_apiSession;
    
    NSString* rootFolderPath = [ SCSite mediaLibraryDefaultPath ];

    
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

-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
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

-(void)didFailLoadingRootItemWithError:(NSError*)error
{
    [ sc_ErrorHelper showError: error.localizedDescription ];
    [ self endLoading ];
}

-(void)didLoadRootItem:(SCItem*)rootItem
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
-(void)itemsBrowser:(id)sender
didReceiveLevelProgressNotification:(id)progressInfo
{
    [ self startLoading ];
}

-(void)itemsBrowser:(id)sender
levelLoadingFailedWithError:(NSError*)error
{
    [ sc_ErrorHelper showError: error.localizedDescription ];
    [ self endLoading ];
}

-(void)itemsBrowser:(id)sender
didLoadLevelForItem:(SCItem*)levelParentItem
{
    NSParameterAssert( nil != levelParentItem );
    
    [ self endLoading ];
    self.itemPathLabel.text = levelParentItem.path;
    
    
    // leaving this on the user's behalf
    NSIndexPath* top = [ NSIndexPath indexPathForRow: 0
                                           inSection: 0 ];
    
    UICollectionView* collectionView = self.cellFactory.itemsBrowserController.collectionView;
    [ collectionView scrollToItemAtIndexPath: top
                            atScrollPosition: UICollectionViewScrollPositionTop
                                    animated: NO ];
}

-(BOOL)itemsBrowser:(id)sender
shouldLoadLevelForItem:(SCItem*)levelParentItem
{
    if ( levelParentItem.isFolder || levelParentItem.hasChildren )
    {
        return YES;
    }
    else
    {
        if ( levelParentItem.isImage )
        {
            sc_QuickImageViewController* quickImageViewController = (sc_QuickImageViewController*)[self.storyboard instantiateViewControllerWithIdentifier: @"sc_QuickImageViewController"];
            quickImageViewController.items = [ self itemsForQuickViewControllerForLevelItem: levelParentItem ];
            quickImageViewController.selectedImage = [ quickImageViewController.items indexOfObject: levelParentItem ];
            quickImageViewController.session = self->_legacyApiSession;
            [self.navigationController pushViewController: quickImageViewController animated: YES];
        }
    }
    
    return NO;
}

-(NSArray*)itemsForBrowsingOnCurrentLevel
{
    NSArray* result = nil;
    
#define INTROSPECT_ITEMS_BROWSER_WITH_RUNTIME 1
#if INTROSPECT_ITEMS_BROWSER_WITH_RUNTIME
    {
        // @adk : breaking incapsulation to avoid cache related errors
        // TODO : fix caching in Mobile SDK if possible
        NSArray* levelItems = [ [ self.gridBrowser performSelector: @selector(loadedLevel) ] performSelector: @selector( levelContentItems ) ];
        
        id levelUpItem = [ levelItems firstMatch: ^BOOL(id singleItem)
        {
            Class SCLevelUpItemClass = NSClassFromString( @"SCLevelUpItem" );
            NSParameterAssert( Nil != SCLevelUpItemClass );
            
            return [ singleItem isMemberOfClass: SCLevelUpItemClass ];
        } ];
        
        NSMutableArray* levelItemsWithoutPlaceholders = [ levelItems mutableCopy ];
        [ levelItemsWithoutPlaceholders removeObject: levelUpItem ];
        
        result = [ NSArray arrayWithArray: levelItemsWithoutPlaceholders ];
    }
#else
    {
        result = levelItem.parent.readChildren;
    }
#endif

    return result;
}

-(NSMutableArray*)itemsForQuickViewControllerForLevelItem:(SCItem*)levelItem
{
    NSArray* allLevelItems = [ self itemsForBrowsingOnCurrentLevel ];

    NSComparator sotrByTypeAndAlphabet = [ self sortResultComparatorForItemsBrowser: nil ];
    NSArray*  items = [ allLevelItems sortedArrayUsingComparator: sotrByTypeAndAlphabet ];

    return [ items mutableCopy ];
}

-(NSComparator)sortResultComparatorForItemsBrowser:(id)sender
{
    NSComparator result = ^NSComparisonResult(SCItem* obj1, SCItem* obj2)
    {
        
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
        
        NSString* name1 = [ obj1.displayName uppercaseString ];
        NSString* name2 = [ obj2.displayName uppercaseString ];
        
        return [ name1 compare: name2 ];
        
    };
    
    return result;
}

@end
