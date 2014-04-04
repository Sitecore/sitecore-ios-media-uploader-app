#import "sc_ListBrowserViewController.h"
#import "sc_GlobalDataObject.h"
#import "sc_ItemHelper.h"
#import "sc_LevelUpTableCell.h"
#import "sc_FolderTableCell.h"

@interface sc_ListBrowserViewController ()
<
SCItemsBrowserDelegate,
SIBListModeAppearance ,
SIBListModeCellFactory
>

@property (strong, nonatomic) IBOutlet SCItemListBrowser *itemsBrowserController;

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
}

-(void)setSiteForBrowse:(sc_Site *)site
{
    self->_siteForBrowse = site;
    
    self->_legacyApiSession = [ sc_ItemHelper getContext:self->_siteForBrowse ];
    self->_apiSession = self->_legacyApiSession.extendedApiSession;
    
   // self.cellFactory.itemsBrowserController.apiSession = self->_apiSession;

}

-(void)viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear: animated ];
    self.itemsBrowserController.apiSession = self->_apiSession;
    
    
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
    
    NSArray *templatesList = @[@"Media folder"];
    self->_requestBuilder = [ [SIBWhiteListTemplateRequestBuilder alloc] initWithTemplateNames: templatesList ];
    self.itemsBrowserController.nextLevelRequestBuilder = self->_requestBuilder;

    NSParameterAssert( nil != self.itemsBrowserController );
}

-(void)didFailLoadingRootItemWithError:( NSError* )error
{
    [ sc_ErrorHelper showError: error.localizedDescription ];
    [ self endLoading ];
}

-(void)didLoadRootItem:( SCItem* )rootItem
{
    self.itemsBrowserController.rootItem = rootItem;
    [ self.itemsBrowserController reloadData ];
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
    [ self goToRootViewController ];
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

#pragma mark -
#pragma mark SIBListModeCellFactory
static NSString* const LEVEL_UP_CELL_ID = @"net.sitecore.MobileSdk.ItemsBrowser.list.LevelUpCell";
static NSString* const FOLDER_CELL_ID     = @"net.sitecore.MobileSdk.ItemsBrowser.list.FolderCell"   ;


-(NSString*)itemsBrowser:( id )sender
itemCellReuseIdentifierForItem:( SCItem* )item
{
    return FOLDER_CELL_ID;
}

-(NSString*)reuseIdentifierForLevelUpCellOfItemsBrowser:( id )sender
{
    return LEVEL_UP_CELL_ID;
}

-(UITableViewCell*)createLevelUpCellForListModeOfItemsBrowser:( id )sender
{
    sc_LevelUpTableCell* cell = [ [ sc_LevelUpTableCell alloc ] initWithStyle: UITableViewCellStyleDefault
                                                              reuseIdentifier: LEVEL_UP_CELL_ID ];
    return cell;
}

-(UITableViewCell<SCItemCell>*)itemsBrowser:( id )sender
                  createListModeCellForItem:( SCItem* )item
{
    NSString* cellId = [ self itemsBrowser: self->_itemsBrowserController
            itemCellReuseIdentifierForItem: item ];
    
    sc_FolderTableCell* cell = [ [ sc_FolderTableCell alloc ] initWithStyle: UITableViewCellStyleDefault
                                                            reuseIdentifier: cellId ];
    return cell;
}

-(BOOL)itemsBrowser:( id )sender
shouldLoadLevelForItem:( SCItem* )levelParentItem
{
    return levelParentItem.isFolder || levelParentItem.hasChildren;
}

@end
