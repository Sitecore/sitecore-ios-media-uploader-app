#import "MUButtonTheme.h"

@implementation MUButtonTheme

#pragma mark - 
#pragma mark case CUSTOMBUTTONTYPE_NORMAL
-(UIColor*)colorForNormalStateOfNormalButton
{
    // @"greyButton"
    
    // #E3E3E3
    UIColor* result = [ UIColor colorWithWhite: 227.f / 255.f
                                         alpha: 1.f ];
    
    return result;
}

-(UIColor*)colorForHighlightedStateOfNormalButton
{
    // @adk : a randomly modified placeholder
    
    // #A6A6A6
    UIColor* result = [ UIColor colorWithWhite: 166.f / 255.f
                                         alpha: 1.f ];

    return result;
}


#pragma mark -
#pragma mark case CUSTOMBUTTONTYPE_DANGEROUS
-(UIColor*)colorForNormalStateOfDangerousButton
{
    // RED
    UIColor* result = [ UIColor colorWithRed: 0.875f
                                       green: 0.349f
                                        blue: 0.243f
                                       alpha: 1.f ]; /*#df593e*/
    
    return result;
}

-(UIColor*)colorForHighlightedStateOfDangerousButton
{
    // RED
    UIColor* result = [ UIColor colorWithRed: 0.925f
                                       green: 0.616f
                                        blue: 0.553f
                                       alpha: 1.f ]; /*#ec9d8d*/

    return result;
}


#pragma mark -
#pragma mark case CUSTOMBUTTONTYPE_IMPORTANT
-(UIColor*)colorForNormalStateOfImportantButton
{
    // #5c9bce
    UIColor* result = [ UIColor colorWithRed:  92.f / 255.f
                                       green: 155.f / 255.f
                                        blue: 206.f / 255.f
                                       alpha: 1.f ];
    
    return result;
}

-(UIColor*)colorForHighlightedStateOfImportantButton
{
    // #97bfe0
    UIColor* result = [ UIColor colorWithRed: 0.592f
                                       green: 0.749f
                                        blue: 0.878f
                                       alpha: 1.f ];
    return result;
}



#pragma mark -
#pragma mark case CUSTOMBUTTONTYPE_TRANSPARENT
-(UIColor*)colorForNormalStateOfTransparentButton
{
    // @"transparentButton."
    UIColor* result = [ UIColor lightGrayColor ];
    
    return result;
}

-(UIColor*)colorForHighlightedStateOfTransparentButton
{
    // @adk : a randomly modified placeholder
    
    UIColor* result = [ UIColor grayColor ];
    
    return result;
}


#pragma mark -
#pragma mark case default
-(UIColor*)colorForNormalStateOfButtonWithUndefinedType
{
    // @"greyButton"
    UIColor* result = [ self colorForNormalStateOfNormalButton ];
    
    return result;
}

-(UIColor*)colorForHighlightedStateOfButtonWithUndefinedType
{
    // @adk : a randomly modified placeholder
    UIColor* result = [ self colorForHighlightedStateOfNormalButton ];
    
    return result;
}

@end

