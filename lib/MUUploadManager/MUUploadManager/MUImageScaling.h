#import <Foundation/Foundation.h>


@interface MUImageScaling : NSObject

+(UIImage*)scaleImage:(UIImage*)image
               toSize:(CGSize)size;

+(CGFloat)scaleCoefficientToResizeImageWithSize:(CGSize)originalSize
                                         toSize:(CGSize)resultSize;

@end
