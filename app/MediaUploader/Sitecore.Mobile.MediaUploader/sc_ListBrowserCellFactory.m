#import "sc_ListBrowserCellFactory.h"
#import "sc_LevelUpTableCell.h"
#import "sc_FolderTableCell.h"

@implementation sc_ListBrowserCellFactory


#pragma mark -
#pragma mark SIBListModeCellFactory
static NSString* const LEVEL_UP_CELL_ID = @"net.sitecore.MobileSdk.ItemsBrowser.list.LevelUpCell";
static NSString* const FOLDER_CELL_ID     = @"net.sitecore.MobileSdk.ItemsBrowser.list.FolderCell"   ;


-(NSString*)itemsBrowser:(id)sender
itemCellReuseIdentifierForItem:(SCItem*)item
{
    return FOLDER_CELL_ID;
}

-(NSString*)reuseIdentifierForLevelUpCellOfItemsBrowser:(id)sender
{
    return LEVEL_UP_CELL_ID;
}

-(UITableViewCell*)createLevelUpCellForListModeOfItemsBrowser:(id)sender
{
    sc_LevelUpTableCell* cell = [ [ sc_LevelUpTableCell alloc ] initWithStyle: UITableViewCellStyleDefault
                                                              reuseIdentifier: LEVEL_UP_CELL_ID ];
    return cell;
}

-(UITableViewCell<SCItemCell>*)itemsBrowser:(id)sender
                  createListModeCellForItem:(SCItem*)item
{
    NSString* cellId = [ self itemsBrowser: self->_itemsBrowserController
            itemCellReuseIdentifierForItem: item ];
    
    sc_FolderTableCell* cell = [ [ sc_FolderTableCell alloc ] initWithStyle: UITableViewCellStyleDefault
                                                            reuseIdentifier: cellId ];
    return cell;
}

@end
