#import "sc_LevelUpTableCell.h"

@implementation sc_LevelUpTableCell
{
    UIImageView *_iconView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [ self setupUI ];
    }
    
    return self;
}
    
-(UIImage *)iconImage
{
    return [UIImage imageNamed:@"up"];
}

-(void)setupUI
{
    [ self.imageView setImage: [ self iconImage ] ];
}

@end
