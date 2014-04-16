#import "sc_FolderGridCell.h"

@implementation sc_FolderGridCell

{
    UILabel*  _label;
    NSString* _displayName;
    UIImageView *_folderIconView;
}

-(instancetype)initWithFrame:(CGRect )frame
{
    self = [ super initWithFrame: frame ];
    if ( nil == self )
    {
        return nil;
    }
    
    [ self setupUI ];
    
    return self;
}

-(UIImage*)folderIconImage
{
    return [UIImage imageNamed:@"folder"];
}

-(void)setupUI
{
    CGRect iconFrame = self.contentView.frame;
    iconFrame.origin = CGPointMake( 0, 0 );
    iconFrame.size.height -= 20;
    
    self->_folderIconView = [ [UIImageView alloc] initWithFrame: iconFrame ];
    [ self->_folderIconView setImage: [ self folderIconImage ] ];
    self->_folderIconView.contentMode = UIViewContentModeCenter;
    
    CGRect labelFrame = self.contentView.frame;
    labelFrame.origin = CGPointMake( 0, 0 );
    labelFrame.size.height = 20;
    labelFrame.origin.y = iconFrame.size.height;
    
    self->_label = [ [ UILabel alloc ] initWithFrame: labelFrame ];
    self->_label.textAlignment = NSTextAlignmentCenter;
    
    [ self.contentView addSubview:  self->_folderIconView ];
    [ self.contentView addSubview: self->_label ];
}

-(void)setModel:(SCItem*)item
{
    self->_displayName = item.displayName;
}

-(void)reloadData
{
    self->_label.text = self->_displayName;
}

@end
