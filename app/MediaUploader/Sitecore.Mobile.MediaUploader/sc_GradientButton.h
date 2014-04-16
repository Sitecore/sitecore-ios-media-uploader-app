#import <CoreGraphics/CoreGraphics.h>

typedef enum _CustomButtonType
{
    CUSTOMBUTTONTYPE_NORMAL = 0,
    CUSTOMBUTTONTYPE_DANGEROUS = 1,
    CUSTOMBUTTONTYPE_IMPORTANT = 2,
    CUSTOMBUTTONTYPE_TRANSPARENT = 3
} CustomButtonType;


@interface sc_GradientButton : UIButton

-(void)setButtonWithStyle:(CustomButtonType)customButtonType;

@end