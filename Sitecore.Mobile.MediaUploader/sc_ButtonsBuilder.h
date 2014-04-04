#import <Foundation/Foundation.h>
#import "sc_GradientButton.h"

@interface sc_ButtonsBuilder : NSObject

-(sc_GradientButton *)getButtonWithTitle:(NSString *)title
                                   style:(CustomButtonType) customButtonType
                                  target:(id)target
                                selector:(SEL)selector;

@end
