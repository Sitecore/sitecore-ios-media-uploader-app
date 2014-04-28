#import "MUButtonTheme.h"


//allColors_ = @[
//               // Blue
//                 [ UIColor colorWithRed: 0.592f green: 0.749f blue: 0.878f alpha: 1.f ] /*#97bfe0*/
//               , [ UIColor colorWithRed: 0.651f green: 0.788f blue: 0.898f alpha: 1.f ] /*#a6c9e5*/
//               , [ UIColor colorWithRed: 0.796f green: 0.875f blue: 0.937f alpha: 1.f ] /*#cbdfef*/
//               // Green
//               , [ UIColor colorWithRed: 0.486f green: 0.663f blue: 0.4f   alpha: 1.f ] /*#7ca966*/
//               , [ UIColor colorWithRed: 0.565f green: 0.714f blue: 0.49f  alpha: 1.f ] /*#90b67d*/
//               , [ UIColor colorWithRed: 0.741f green: 0.831f blue: 0.698f alpha: 1.f ] /*#bdd4b2*/
//               // Yellow
//               , [ UIColor colorWithRed: 1.f    green: 0.851f blue: 0.298f alpha: 1.f ] /*#ffd94c*/
//               , [ UIColor colorWithRed: 1.f    green: 0.875f blue: 0.404f alpha: 1.f ] /*#ffdf67*/
//               , [ UIColor colorWithRed: 1.f    green: 0.925f blue: 0.647f alpha: 1.f ] /*#ffeca5*/
//               // Orange
//               , [ UIColor colorWithRed: 1.f    green: 0.561f blue: 0.298f alpha: 1.f ] /*#ff8f4c*/
//               , [ UIColor colorWithRed: 1.f    green: 0.627f blue: 0.404f alpha: 1.f ] /*#ffa067*/
//               , [ UIColor colorWithRed: 1.f    green: 0.78f  blue: 0.647f alpha: 1.f ] /*#ffc7a5*/
//               // Red
//               , [ UIColor colorWithRed: 0.875f green: 0.349f blue: 0.243f alpha: 1.f ] /*#df593e*/
//               , [ UIColor colorWithRed: 0.925f green: 0.616f blue: 0.553f alpha: 1.f ] /*#ec9d8d*/
//               , [ UIColor colorWithRed: 0.941f green: 0.878f blue: 0.784f alpha: 1.f ] /*#f0e0c8*/
//               // Brown
//               , [ UIColor colorWithRed: 0.831f green: 0.765f blue: 0.447f alpha: 1.f ] /*#d4c372*/
//               , [ UIColor colorWithRed: 0.855f green: 0.8f   blue: 0.529f alpha: 1.f ] /*#dacc87*/
//               , [ UIColor colorWithRed: 0.914f green: 0.882f blue: 0.722f alpha: 1.f ] /*#e9e1b8*/
//               // Gray
//               , [ UIColor colorWithRed: 0.882f green: 0.757f blue: 0.573f alpha: 1.f ] /*#e1c192*/
//               , [ UIColor colorWithRed: 0.898f green: 0.792f blue: 0.635f alpha: 1.f ] /*#e5caa2*/
//               , [ UIColor colorWithRed: 0.941f green: 0.878f blue: 0.784f alpha: 1.f ] /*#f0e0c8*/
//               ];


//-(UIColor*)allTrafficTypesColor
//{
//    return [ UIColor colorForHex: @"A6A6A6" ];
//}
//
//-(UIColor*)otherTrafficTypesColor
//{
//    return [ UIColor colorForHex: @"E3E3E3" ];
//}



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

