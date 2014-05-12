#import <UIKit/UIKit.h>


@interface sc_ActivityIndicator : UIView

-(instancetype)initWithFrame:(CGRect)frame;

-(void)showWithLabel:(NSString*)label
          afterDelay:(float)wait;

-(void)showWithLabel:(NSString*)label;
-(void)hide;

@end
