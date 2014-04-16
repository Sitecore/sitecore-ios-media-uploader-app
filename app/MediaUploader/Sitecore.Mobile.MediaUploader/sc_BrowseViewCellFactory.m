#import "sc_BrowseViewCellFactory.h"
#import <SitecoreItemsBrowser/Grid/Animation/SCHighlightableBackgroundGridCell.h>
#import "sc_FolderGridCell.h"
#import "sc_LevelUpGridCell.h"

@implementation sc_BrowseViewCellFactory

#pragma mark -
#pragma mark SIBGridModeCellFactory
static NSString* const LEVEL_UP_CELL_ID  = @"net.sitecore.MobileSdk.ItemsBrowser.list.LevelUpCell"   ;
static NSString* const ITEM_CELL_ID      = @"net.sitecore.MobileSdk.ItemsBrowser.list.ItemCell"      ;
static NSString* const IMAGE_CELL_ID     = @"net.sitecore.MobileSdk.ItemsBrowser.list.ItemCell.image";

-(NSString*)levelUpCellReuseId
{
    return LEVEL_UP_CELL_ID;
}

-(NSString*)reuseIdentifierForItem:(SCItem*)item
{
    if ( [ item isMediaImage ] )
    {
        return IMAGE_CELL_ID;
    }
    else
    {
        return ITEM_CELL_ID;
    }
}

-(Class)levelUpCellClass
{
    return [ sc_LevelUpGridCell class ];
}

-(Class)cellClassForItem:(SCItem*)item
{
    if ( [ item isMediaImage ] )
    {
        return [ SCMediaItemGridCell class ];
    }
    else
    {
        return [ sc_FolderGridCell class ];
    }
}

-(UICollectionViewCell*)itemsBrowser:(SCItemGridBrowser*)sender
        createLevelUpCellAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* reuseId = [ self levelUpCellReuseId ];
    Class levelUpCellClass = [ self levelUpCellClass ];
    
    UICollectionView* collectionView = self->_itemsBrowserController.collectionView;
    [ collectionView registerClass: levelUpCellClass
        forCellWithReuseIdentifier: reuseId ];
    
    sc_LevelUpGridCell* result =
    [ collectionView dequeueReusableCellWithReuseIdentifier: reuseId
                                               forIndexPath: indexPath ];

    [ self setColorsForCell: result ];
    
    return result;
}

-(void)setColorsForCell:(UICollectionViewCell*)cell
{
    cell.backgroundColor = [ UIColor whiteColor ];
    
    UICollectionViewCell<SCHighlightableBackgroundGridCell>* gridCell = (UICollectionViewCell<SCHighlightableBackgroundGridCell>*)cell;
    [ gridCell setBackgroundColorForNormalState: [ UIColor whiteColor ] ];
    [ gridCell setBackgroundColorForHighlightedState: [ UIColor grayColor ] ];
}

-(UICollectionViewCell<SCItemCell>*)itemsBrowser:(SCItemGridBrowser*)sender
                       createGridModeCellForItem:(SCItem*)item
                                     atIndexPath:(NSIndexPath*)indexPath
{
    NSString* reuseId = [ self reuseIdentifierForItem: item ];
    Class levelUpCellClass = [ self cellClassForItem: item ];
    
    UICollectionView* collectionView = self->_itemsBrowserController.collectionView;
    [ collectionView registerClass: levelUpCellClass
        forCellWithReuseIdentifier: reuseId ];
    
    UICollectionViewCell<SCItemCell>* result =
    [ collectionView dequeueReusableCellWithReuseIdentifier: reuseId
                                               forIndexPath: indexPath ];
    
    if ([result respondsToSelector:@selector(setImageResizingOptions:)])
    {
        SCDownloadMediaOptions* imageResizingOptions = [ SCDownloadMediaOptions new ];
        imageResizingOptions.displayAsThumbnail = YES;
        [ result performSelector: @selector(setImageResizingOptions:)
                      withObject: imageResizingOptions ];
    }
    
    [ self setColorsForCell: result ];
    
    return result;
}

@end
