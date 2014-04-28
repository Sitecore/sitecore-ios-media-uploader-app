#import "sc_ListBrowserViewController.h"
#import "sc_ItemHelper.h"
#import "sc_LevelUpTableCell.h"
#import "sc_FolderTableCell.h"
#import "sc_ListBrowserCellFactory.h"
#import "sc_GridBrowserRequestBuilder.h"


@interface sc_ListBrowserViewController ()<SCItemsBrowserDelegate>

@property (nonatomic, strong) IBOutlet sc_ListBrowserCellFactory* cellFactory;

@property (weak, nonatomic) IBOutlet UITextView* itemPathTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* loadingProgress;

-(IBAction)cancelTouched:(id)sender;
-(IBAction)useTouched:(id)sender;

@end


@implementation sc_ListBrowserViewController
{
    SCApiSession* _legacyApiSession;
    SCExtendedApiSession* _apiSession;
    
    sc_GridBrowserRequestBuilder* _requestBuilder;
    SCSite* _siteForBrowse;
    NSString* _currentPath;
    SCUPloadFolderReceived _callback;
}

-(void)chooseUploaderFolderForSite:(SCSite*)site witCallback:(SCUPloadFolderReceived)callback
{
    self->_callback = callback;
    self->_siteForBrowse = site;
    
    self->_legacyApiSession = [ sc_ItemHelper getContext: self->_siteForBrowse ];
    self->_apiSession = self->_legacyApiSession.extendedApiSession;
    
    self.cellFactory.itemsBrowserController.apiSession = self->_apiSession;
}

-(void)viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear: animated ];
    self.cellFactory.itemsBrowserController.apiSession = self->_apiSession;
    

    NSString* rootFolderPath = [ SCSite mediaLibraryDefaultPath ];
    
    SCExtendedAsyncOp rootItemLoader =
    [ self->_apiSession readItemOperationForItemPath: rootFolderPath
                                          itemSource: nil ];
    
    [ self startLoading ];
    __weak sc_ListBrowserViewController* weakSelf = self;
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
           self->_currentPath = rootItem.path;
       }
    } );
}

-(void)viewDidLoad
{
    [ super viewDidLoad ];
    
    self.itemPathTextView.text = @"";
    
    NSArray* templatesList = @[@"Media folder"];
    self->_requestBuilder = [ [sc_GridBrowserRequestBuilder alloc] initWithTemplateNames: templatesList ];
    self.cellFactory.itemsBrowserController.nextLevelRequestBuilder = self->_requestBuilder;
    self.cellFactory.itemsBrowserController.nextLevelRequestBuilder = self->_requestBuilder;
    
    NSParameterAssert( nil != self.cellFactory.itemsBrowserController );
}

-(void)didFailLoadingRootItemWithError:(NSError*)error
{
    [ sc_ErrorHelper showError: error.localizedDescription ];
    [ self.navigationController popViewControllerAnimated: YES ];
    [ self endLoading ];
}

-(void)didLoadRootItem:(SCItem*)rootItem
{
    self.cellFactory.itemsBrowserController.rootItem = rootItem;
    [ self.cellFactory.itemsBrowserController reloadData ];
}

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

-(IBAction)cancelTouched:(id)sender
{
    [ self.navigationController popViewControllerAnimated: YES ];
}

-(IBAction)useTouched:(id)sender
{
    self->_callback( self->_currentPath );
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

-(void)itemsBrowser:(id)sender didLoadLevelForItem:(SCItem*)levelParentItem
{
    NSParameterAssert( nil != levelParentItem );
    
    [ self endLoading ];
    self.itemPathTextView.text = levelParentItem.path;
    self->_currentPath = levelParentItem.path;
}

-(BOOL)itemsBrowser:(id)sender shouldLoadLevelForItem:(SCItem*)levelParentItem
{
    return levelParentItem.isFolder || levelParentItem.hasChildren;
}

@end
