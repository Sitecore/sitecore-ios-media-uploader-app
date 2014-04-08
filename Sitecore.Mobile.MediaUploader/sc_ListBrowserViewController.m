#import "sc_ListBrowserViewController.h"
#import "sc_GlobalDataObject.h"
#import "sc_ItemHelper.h"
#import "sc_LevelUpTableCell.h"
#import "sc_FolderTableCell.h"
#import "sc_ListBrowserCellFactory.h"

@interface sc_ListBrowserViewController ()<SCItemsBrowserDelegate>

@property (nonatomic, strong) IBOutlet sc_ListBrowserCellFactory *cellFactory;

@property (weak, nonatomic) IBOutlet UITextView *itemPathTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingProgress;

-(IBAction)cancelTouched:(id)sender;
-(IBAction)useTouched:(id)sender;

@end

@implementation sc_ListBrowserViewController
{
    SCApiSession* _legacyApiSession;
    SCExtendedApiSession* _apiSession;
    
    sc_GlobalDataObject *_appDataObject;
    SIBWhiteListTemplateRequestBuilder *_requestBuilder;
    sc_Site *_siteForBrowse;
    NSString *_currentPath;
    BOOL _editMode;
}

-(void)setSiteForBrowse:(sc_Site *)site editMode:(BOOL)editMode
{
    self->_editMode = editMode;
    
    self->_siteForBrowse = site;
    
    self->_legacyApiSession = [ sc_ItemHelper getContext:self->_siteForBrowse ];
    self->_apiSession = self->_legacyApiSession.extendedApiSession;
    
    self.cellFactory.itemsBrowserController.apiSession = self->_apiSession;
}

-(void)viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear: animated ];
    self.cellFactory.itemsBrowserController.apiSession = self->_apiSession;
    
    NSString *rootFolderPath = [ sc_Site mediaLibraryDefaultPath ];
    
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
    
    _appDataObject = [ sc_GlobalDataObject getAppDataObject ];
    
    NSArray *templatesList = @[@"Media folder"];
    self->_requestBuilder = [ [SIBWhiteListTemplateRequestBuilder alloc] initWithTemplateNames: templatesList ];
    self.cellFactory.itemsBrowserController.nextLevelRequestBuilder = self->_requestBuilder;
    self.cellFactory.itemsBrowserController.nextLevelRequestBuilder = self->_requestBuilder;
    
    NSParameterAssert( nil != self.cellFactory.itemsBrowserController );
}

-(void)didFailLoadingRootItemWithError:( NSError* )error
{
    [ sc_ErrorHelper showError: error.localizedDescription ];
    [ self.navigationController popViewControllerAnimated: YES ];
    [ self endLoading ];
}

-(void)didLoadRootItem:( SCItem* )rootItem
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
    [ self goToRootViewController ];
}

-(IBAction)useTouched:(id)sender
{
    self->_siteForBrowse.uploadFolderPathInsideMediaLibrary = self->_currentPath;
    
    NSError *error;
    
    if ( self->_editMode )
    {
        [ _appDataObject.sitesManager saveSites ];
    }
    else
    {
        [ _appDataObject.sitesManager addSite: self->_siteForBrowse
                                        error: &error ];
    }
    
    if ( error )
    {
        [sc_ErrorHelper showError:NSLocalizedString(error.localizedDescription, nil)];
    }
    else
    {
        [ self goToRootViewController ];
    }
}

-(void)goToRootViewController
{
    NSUInteger vcCount = [ self.navigationController.viewControllers count ];
    NSUInteger stepsToSttingsRoot = 3;
    if ( vcCount < stepsToSttingsRoot )
    {
        [ self.navigationController popToRootViewControllerAnimated: YES ];
        return;
    }
    
    UIViewController *vcToPop = self.navigationController.viewControllers[ vcCount - stepsToSttingsRoot ];
    
    [ self.navigationController popToViewController:vcToPop animated:YES ];
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
    [ sc_ErrorHelper showError:error.localizedDescription ];
    [ self endLoading ];
}

-(void)itemsBrowser:( id )sender didLoadLevelForItem:( SCItem* )levelParentItem
{
    NSParameterAssert( nil != levelParentItem );
    
    [ self endLoading ];
    self.itemPathTextView.text = levelParentItem.path;
    self->_currentPath = levelParentItem.path;
}

-(BOOL)itemsBrowser:( id )sender shouldLoadLevelForItem:( SCItem* )levelParentItem
{
    return levelParentItem.isFolder || levelParentItem.hasChildren;
}

@end
