#import <Foundation/Foundation.h>

@class UIColor;


@protocol MUButtonThemeProtocol

-(UIColor*)colorForNormalStateOfNormalButton;
-(UIColor*)colorForHighlightedStateOfNormalButton;

-(UIColor*)colorForNormalStateOfDangerousButton;
-(UIColor*)colorForHighlightedStateOfDangerousButton;


-(UIColor*)colorForNormalStateOfImportantButton;
-(UIColor*)colorForHighlightedStateOfImportantButton;


-(UIColor*)colorForNormalStateOfTransparentButton;
-(UIColor*)colorForHighlightedStateOfTransparentButton;


-(UIColor*)colorForNormalStateOfButtonWithUndefinedType;
-(UIColor*)colorForHighlightedStateOfButtonWithUndefinedType;

@end


@interface MUButtonTheme : NSObject<MUButtonThemeProtocol>

@end
