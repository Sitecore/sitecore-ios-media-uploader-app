#import "sc_FolderTableCell.h"

@implementation sc_FolderTableCell
{
    NSString* _itemName;
}

-(UIImage* )iconImage
{
    return [UIImage imageNamed:@"folder"];
}

-(void)setModel:(SCItem *)item
{
    [ self.imageView setImage:[ self iconImage ] ];
    self->_itemName = item.displayName;
}

-(void)reloadData
{
    self.textLabel.text = self->_itemName;
}

@end
