#import "MUButtonTheme.h"


@implementation MUButtonTheme

#pragma mark - 
#pragma mark case CUSTOMBUTTONTYPE_NORMAL
-(UIColor*)colorForNormalStateOfNormalButton
{
    // @"greyButton"
    
    UIColor* result = [ UIColor colorWithWhite: 236.f / 255.f
                                         alpha: 1.f ];
    
    return result;
}

-(UIColor*)colorForHighlightedStateOfNormalButton
{
    // @adk : a randomly modified placeholder
    UIColor* result = [ UIColor colorWithWhite: 200.f / 255.f
                                         alpha: 1.f ];

    return result;
}


#pragma mark -
#pragma mark case CUSTOMBUTTONTYPE_DANGEROUS
-(UIColor*)colorForNormalStateOfDangerousButton
{
    // @"orangeButton"
    
    UIColor* result = [ UIColor colorWithRed: 163.f / 255.f
                                       green:  45.f / 255.f
                                        blue:  37.f / 255.f
                                       alpha: 1.f ];
    
    return result;
}

-(UIColor*)colorForHighlightedStateOfDangerousButton
{
    // @adk : a randomly modified placeholder
    
    UIColor* result = [ UIColor colorWithRed: 100.f / 255.f
                                       green:  45.f / 255.f
                                        blue:  37.f / 255.f
                                       alpha: 1.f ];
    
    return result;
}


#pragma mark -
#pragma mark case CUSTOMBUTTONTYPE_IMPORTANT
-(UIColor*)colorForNormalStateOfImportantButton
{
    // @"blueButton"
    
    UIColor* result = [ UIColor colorWithRed:  82.f / 255.f
                                       green: 129.f / 255.f
                                        blue: 255.f / 255.f
                                       alpha: 1.f ];
    
    return result;
}

-(UIColor*)colorForHighlightedStateOfImportantButton
{
    // @adk : a randomly modified placeholder
    
    UIColor* result = [ UIColor colorWithRed:  82.f / 255.f
                                       green: 129.f / 255.f
                                        blue: 200.f / 255.f
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

