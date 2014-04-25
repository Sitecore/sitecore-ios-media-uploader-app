
#import "sc_GradientButton.h"


@implementation sc_GradientButton
{
    BOOL _isInitialized;
    
    UIColor* _colorForNormalState;
    UIColor* _colorForHighlightedState;
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
//            normalImageName = [self formatImageName: @"greyButton" iosVersion: iosVersionPostfix];
//            highlightedlImageName = [self formatImageName: @"blueButtonHighlight" iosVersion: iosVersionPostfix];

            self->_colorForHighlightedState =
            [ UIColor colorWithWhite: 200.f / 255.f
                               alpha: 1.f ];
            
            self->_colorForNormalState =
            [ UIColor colorWithWhite: 236.f / 255.f
                               alpha: 1.f ];
            
            nornalTitleColor      = [ UIColor blackColor ];
            highlightedTitleColor = [ UIColor whiteColor ];
            
            break;
        }
        case (CUSTOMBUTTONTYPE_DANGEROUS):
        {
//            normalImageName = [self formatImageName: @"orangeButton" iosVersion: iosVersionPostfix];
//            highlightedlImageName = [self formatImageName: @"orangeButtonHighlight" iosVersion: iosVersionPostfix];

            
            self->_colorForHighlightedState =
            [ UIColor colorWithRed: 100.f / 255.f
                             green:  45.f / 255.f
                              blue:  37.f / 255.f
                             alpha: 1.f ];

            
            self->_colorForNormalState =
            [ UIColor colorWithRed: 163.f / 255.f
                             green:  45.f / 255.f
                              blue:  37.f / 255.f
                             alpha: 1.f ];
            
            nornalTitleColor      = [ UIColor whiteColor ];
            highlightedTitleColor = [ UIColor whiteColor ];
            
            break;
        }
        case (CUSTOMBUTTONTYPE_IMPORTANT):
        {
//            normalImageName = [self formatImageName: @"blueButton" iosVersion: iosVersionPostfix];
//            highlightedlImageName = [self formatImageName: @"blueButtonHighlight" iosVersion: iosVersionPostfix];

            
            // @adk : numbers for testing
            self->_colorForHighlightedState =
            [ UIColor colorWithRed:  82.f / 255.f
                             green: 129.f / 255.f
                              blue: 200.f / 255.f
                             alpha: 1.f ];
            
            
            self->_colorForNormalState =
            [ UIColor colorWithRed:  82.f / 255.f
                             green: 129.f / 255.f
                              blue: 255.f / 255.f
                             alpha: 1.f ];
            
            nornalTitleColor      = [ UIColor whiteColor ];
            highlightedTitleColor = [ UIColor whiteColor ];
            
            break;
        }
        case (CUSTOMBUTTONTYPE_TRANSPARENT):
        {
//            normalImageName = [self formatImageName: @"transparentButton." iosVersion: iosVersionPostfix];
//            highlightedlImageName = [self formatImageName: @"transparentButtonHighlight" iosVersion: iosVersionPostfix];
            
            self->_colorForNormalState = [ UIColor lightGrayColor ];
            self->_colorForHighlightedState = [ UIColor grayColor ];
            
            nornalTitleColor      = [ UIColor whiteColor ];
            highlightedTitleColor = [ UIColor whiteColor ];
            
            break;
        }
        default:
        {
//            normalImageName = [self formatImageName: @"greyButton" iosVersion: iosVersionPostfix];
//            highlightedlImageName = [self formatImageName: @"greyButtonHighlight" iosVersion: iosVersionPostfix];

            self->_colorForHighlightedState = [ UIColor colorWithWhite: 200.f / 255.f
                                                                 alpha: 1.f ];
            
            self->_colorForNormalState = [ UIColor colorWithWhite: 236.f / 255.f
                                                            alpha: 1.f ];

            nornalTitleColor      = [ UIColor blackColor ];
            highlightedTitleColor = [ UIColor blackColor ];
            
            break;
        }
    }
    
//    self->_colorForHighlightedState = [ UIColor magentaColor ];
    
    [self setTitleColor: [UIColor lightGrayColor] forState: UIControlStateDisabled];
    [self setTitleColor: nornalTitleColor         forState: UIControlStateNormal];
    [self setTitleColor: highlightedTitleColor    forState: UIControlStateHighlighted];

    
    
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
    NSLog(@"%@", NSStringFromSelector( _cmd ) );
    [ self.layer setBackgroundColor: [ self->_colorForHighlightedState CGColor ] ];
}

-(void)buttonDidTouchUp:( id )sender
{
    NSLog(@"%@", NSStringFromSelector( _cmd ) );
    [ self.layer setBackgroundColor: [ self->_colorForNormalState CGColor ] ];
}

@end
