
#import "sc_GradientButton.h"

#import "MUButtonTheme.h"

@implementation sc_GradientButton
{
    BOOL _isInitialized;
    
    UIColor* _colorForNormalState;
    UIColor* _colorForHighlightedState;
}

-(id<MUButtonThemeProtocol>)buttonTheme
{
    static MUButtonTheme* result = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^void()
    {
        result = [ MUButtonTheme new ];
    } );

    return result;
}

-(void)setButtonWithStyle:(CustomButtonType)customButtonType
{
    NSParameterAssert( !self->_isInitialized );
    self->_isInitialized = YES;
    
    
    UIColor* nornalTitleColor      = nil;
    UIColor* highlightedTitleColor = nil;

    
    switch (customButtonType)
    {
        case (CUSTOMBUTTONTYPE_NORMAL):
        {
            self->_colorForHighlightedState =
            [ [ self buttonTheme ] colorForHighlightedStateOfNormalButton ];
            
            self->_colorForNormalState =
            [ [ self buttonTheme ] colorForNormalStateOfNormalButton ];
            
            nornalTitleColor      = [ UIColor blackColor ];
            highlightedTitleColor = [ UIColor whiteColor ];
            
            break;
        }
        case (CUSTOMBUTTONTYPE_DANGEROUS):
        {
            self->_colorForHighlightedState =
            [ [ self buttonTheme ] colorForHighlightedStateOfDangerousButton ];
            
            self->_colorForNormalState =
            [ [ self buttonTheme ] colorForNormalStateOfDangerousButton ];
            
            nornalTitleColor      = [ UIColor whiteColor ];
            highlightedTitleColor = [ UIColor whiteColor ];
            
            break;
        }
        case (CUSTOMBUTTONTYPE_IMPORTANT):
        {
            self->_colorForHighlightedState =
            [ [ self buttonTheme ] colorForHighlightedStateOfImportantButton ];
            
            self->_colorForNormalState =
            [ [ self buttonTheme ] colorForNormalStateOfImportantButton ];
            
            nornalTitleColor      = [ UIColor whiteColor ];
            highlightedTitleColor = [ UIColor whiteColor ];
            
            break;
        }
        case (CUSTOMBUTTONTYPE_TRANSPARENT):
        {
            self->_colorForNormalState =
            [ [ self buttonTheme ] colorForNormalStateOfTransparentButton ];
            
            self->_colorForHighlightedState =
            [ [ self buttonTheme ] colorForHighlightedStateOfTransparentButton ];
            
            nornalTitleColor      = [ UIColor whiteColor ];
            highlightedTitleColor = [ UIColor whiteColor ];
            
            break;
        }
        default:
        {
            self->_colorForNormalState = [ [ self buttonTheme ] colorForNormalStateOfButtonWithUndefinedType ];
            
            self->_colorForHighlightedState =
            [ [ self buttonTheme ] colorForHighlightedStateOfButtonWithUndefinedType ];

            nornalTitleColor      = [ UIColor blackColor ];
            highlightedTitleColor = [ UIColor blackColor ];
            
            break;
        }
    }
    
    
    [ self setTitleColor: [ UIColor lightGrayColor ]
                forState: UIControlStateDisabled ];
    
    [ self setTitleColor: nornalTitleColor
                forState: UIControlStateNormal ];
    
    [ self setTitleColor: highlightedTitleColor
                forState: UIControlStateHighlighted ];


    [ self setupBackgroundColorEvents ];
}

-(void)setupBackgroundColorEvents
{
    [ self.layer setBackgroundColor: [ self->_colorForNormalState CGColor ] ];
    
    
    static const UIControlEvents BUTTON_TOUCH_DOWN =
    UIControlEventTouchDown      |
    UIControlEventTouchDownRepeat;
    
    [ self addTarget: self
              action: @selector( buttonDidTouchDown: )
    forControlEvents: BUTTON_TOUCH_DOWN ];
    
    
    
    static const UIControlEvents BUTTON_TOUCH_UP =
    UIControlEventTouchUpInside  |
    UIControlEventTouchUpOutside |
    UIControlEventTouchCancel    ;
    
    [ self addTarget: self
              action: @selector( buttonDidTouchUp: )
    forControlEvents: BUTTON_TOUCH_UP ];
}

-(void)buttonDidTouchDown:( id )sender
{
//    NSLog(@"%@", NSStringFromSelector( _cmd ) );
    [ self.layer setBackgroundColor: [ self->_colorForHighlightedState CGColor ] ];
}

-(void)buttonDidTouchUp:( id )sender
{
//    NSLog(@"%@", NSStringFromSelector( _cmd ) );
    [ self.layer setBackgroundColor: [ self->_colorForNormalState CGColor ] ];
}

@end
