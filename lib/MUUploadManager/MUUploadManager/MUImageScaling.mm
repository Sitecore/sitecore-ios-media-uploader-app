#import "MUImageScaling.h"

@implementation MUImageScaling


+(UIImage*)scaleImage:(UIImage*)image toSize:(CGSize)size
{
    CGFloat scale = [ self scaleCoefficientToResizeImageWithSize: image.size
                                                          toSize: size ];
    
    if (scale >= 1)
    {
        return image;
    }
    
    CGRect bounds = CGRectMake( 0, 0, image.size.width * scale, image.size.height * scale );
    
    UIGraphicsBeginImageContext( bounds.size );
    [ image drawInRect: CGRectMake( 0.0, 0.0, bounds.size.width, bounds.size.height ) ];
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+(CGFloat)scaleCoefficientToResizeImageWithSize:(CGSize)originalSize toSize:(CGSize)resultSize
{
    if ( resultSize.height < 0 || resultSize.width < 0 )
    {
        return 1.f;
    }
    
    CGFloat targetWidth  = std::max(resultSize.width, resultSize.height);
	CGFloat targetHeight = std::min(resultSize.width, resultSize.height);
    
    if ( originalSize.width < originalSize.height )
    {
        CGFloat tmphWidth = targetWidth;
        targetWidth = targetHeight;
        targetHeight = tmphWidth;
    }
    
	CGFloat width = originalSize.width;
	CGFloat height = originalSize.height;
    
    if ( ( width <= targetWidth )  && ( height <= targetHeight ) )
    {
        return 1.f;
    }
	
	CGFloat scaleFactor = 0.f;
		
    CGFloat widthFactor = targetWidth / width;
    CGFloat heightFactor = targetHeight / height;
    
    scaleFactor = std::min(widthFactor, heightFactor);
    
    return scaleFactor;
}

@end
