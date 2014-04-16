#import "sc_ButtonsBuilder.h"
#import "sc_GlobalDataObject.h"

@implementation sc_ButtonsBuilder
{
    sc_GlobalDataObject* _appDataObject;
}

-(instancetype)init
{
    if (self = [super init])
    {
        self->_appDataObject = [ sc_GlobalDataObject getAppDataObject ];
    }
    
    return self;
}

-(CGFloat)fontSize
{
    if ( _appDataObject.isIpad )
    {
        return 24.f;
    }
    
    return 18.f;
}

-(sc_GradientButton*)getButtonWithTitle:(NSString*)title
                                  style:(CustomButtonType)customButtonType
                                 target:(id)target
                               selector:(SEL)selector
{
    sc_GradientButton* button = [sc_GradientButton buttonWithType:UIButtonTypeCustom];
    [(sc_GradientButton*) button setButtonWithStyle: customButtonType];
    
    [button setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
    CGFloat fontSize = [self fontSize];
    [button.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    
    [ button addTarget: target
                action: selector
      forControlEvents: UIControlEventTouchUpInside ];
    
    return button;
}

@end
