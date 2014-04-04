#import <Foundation/Foundation.h>

@interface sc_ImageScaling : NSObject

+(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;
+(CGFloat)scaleCoefficientToResizeImageWithSize:(CGSize)originalSize toSize:(CGSize)resultSize;

@end
