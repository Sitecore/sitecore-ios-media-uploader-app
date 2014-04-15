#import "sc_LevelUpGridCell.h"

@implementation sc_LevelUpGridCell
{
    UIImageView *_iconView;
}

-(instancetype)initWithFrame:( CGRect )frame
{
    self = [ super initWithFrame: frame ];
    if ( nil == self )
    {
        return nil;
    }
    
    [ self setupUI ];
    
    return self;
}

-(UIImage *)iconImage
{
    return [UIImage imageNamed:@"up"];
}

-(void)setupUI
{
    CGRect iconFrame = self.contentView.frame;
    iconFrame.origin = CGPointMake( 0, 0 );
    
    self->_iconView = [ [UIImageView alloc] initWithFrame: iconFrame ];
    [ self->_iconView setImage: [ self iconImage ] ];
    self->_iconView.contentMode = UIViewContentModeCenter;

    [ self.contentView addSubview:  self->_iconView ];
}


@end
