#import "sc_BrowseViewAppearance.h"


@implementation sc_BrowseViewAppearance

#pragma mark -
#pragma mark SIBGridModeAppearance
-(void)itemsBrowser:(SCItemGridBrowser*)sender
 didUnhighlightCell:(UICollectionViewCell*)cell
            forItem:(SCItem*)item
        atIndexPath:(NSIndexPath*)indexPath
{
    // IDLE
    
    // @adk : to make highlighting animations look nice
}

-(void)itemsBrowser:(SCItemGridBrowser*)sender
   didHighlightCell:(UICollectionViewCell*)cell
            forItem:(SCItem*)item
        atIndexPath:(NSIndexPath*)indexPath
{
    // IDLE
    
    // @adk : to make highlighting animations look nice
}

@end
