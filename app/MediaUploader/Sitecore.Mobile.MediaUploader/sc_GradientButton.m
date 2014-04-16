
#import "sc_GradientButton.h"
@interface sc_GradientButton()
@end

@implementation sc_GradientButton

-(void)setButtonWithStyle:(CustomButtonType) customButtonType
{
    NSString* normalImageName;
    NSString* highlightedlImageName;
    UIColor *nornalTitleColor;
    UIColor *highlightedTitleColor;
    
    NSString* iosVersionPostfix = [[[UIDevice currentDevice] systemVersion] intValue] >= 7 ? @"_7" : @"";
    
    switch (customButtonType)
    {
        case (CUSTOMBUTTONTYPE_NORMAL):
            normalImageName = [self formatImageName:@"greyButton" iosVersion:iosVersionPostfix];
            highlightedlImageName = [self formatImageName:@"blueButtonHighlight" iosVersion:iosVersionPostfix];
            nornalTitleColor = [UIColor blackColor];
            highlightedTitleColor = [UIColor whiteColor];
            break;
        case (CUSTOMBUTTONTYPE_DANGEROUS):
            normalImageName = [self formatImageName:@"orangeButton" iosVersion:iosVersionPostfix];
            highlightedlImageName = [self formatImageName:@"orangeButtonHighlight" iosVersion:iosVersionPostfix];
            nornalTitleColor = [UIColor whiteColor];
            highlightedTitleColor = [UIColor whiteColor];
            break;
        case (CUSTOMBUTTONTYPE_IMPORTANT):
            normalImageName = [self formatImageName:@"blueButton" iosVersion:iosVersionPostfix];
            highlightedlImageName = [self formatImageName:@"blueButtonHighlight" iosVersion:iosVersionPostfix];
            nornalTitleColor = [UIColor whiteColor];
            highlightedTitleColor = [UIColor whiteColor];
            break;
        case (CUSTOMBUTTONTYPE_TRANSPARENT):
            normalImageName = [self formatImageName:@"transparentButton." iosVersion:iosVersionPostfix];
            highlightedlImageName = [self formatImageName:@"transparentButtonHighlight" iosVersion:iosVersionPostfix];
            nornalTitleColor = [UIColor whiteColor];
            highlightedTitleColor = [UIColor whiteColor];
            break;
        default:
            normalImageName = [self formatImageName:@"greyButton" iosVersion:iosVersionPostfix];
            highlightedlImageName = [self formatImageName:@"greyButtonHighlight" iosVersion:iosVersionPostfix];
            nornalTitleColor = [UIColor blackColor];
            highlightedTitleColor = [UIColor blackColor];
            break;
    }
    
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self setTitleColor:nornalTitleColor forState:UIControlStateNormal];
    [self setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
    
    UIImage* buttonImage = [[UIImage imageNamed:normalImageName]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage* buttonImageHighlight = [[UIImage imageNamed:highlightedlImageName]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];

    [self setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
}

-(NSString*)formatImageName:(NSString*)imageName iosVersion:(NSString*) iosVersionPostfix
{
    return [NSString stringWithFormat:@"%@%@.png", imageName,iosVersionPostfix];
}


@end
