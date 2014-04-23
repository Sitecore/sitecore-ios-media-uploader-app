#import <XCTest/XCTest.h>
#import "MUImageScaling.h"

@interface sc_ScaleTest : XCTestCase

@end

@implementation sc_ScaleTest

-(void)testScale
{
    float accuracy = 0.001;
    
    CGSize originalSize = CGSizeMake(1000, 200);
    CGSize resultSize = CGSizeMake(800, 600);
    CGFloat coef = [ MUImageScaling scaleCoefficientToResizeImageWithSize: originalSize toSize: resultSize ];
    
    XCTAssertEqualWithAccuracy(coef, 0.8f, accuracy, @" wrong koef ");
    
    originalSize = CGSizeMake(200, 1000);
    resultSize = CGSizeMake(800, 600);
    coef = [ MUImageScaling scaleCoefficientToResizeImageWithSize: originalSize toSize: resultSize ];
    
    XCTAssertEqualWithAccuracy(coef, 0.8f, accuracy, @" wrong koef ");
    
    originalSize = CGSizeMake(200, 1000);
    resultSize = CGSizeMake(600, 800);
    coef = [ MUImageScaling scaleCoefficientToResizeImageWithSize: originalSize toSize: resultSize ];
    
    XCTAssertEqualWithAccuracy(coef, 0.8f, accuracy, @" wrong koef ");
    
    originalSize = CGSizeMake(200, 200);
    resultSize = CGSizeMake(800, 600);
    coef = [ MUImageScaling scaleCoefficientToResizeImageWithSize: originalSize toSize: resultSize ];
    
    XCTAssertEqualWithAccuracy(coef, 1.f, accuracy, @" wrong koef ");
    
    originalSize = CGSizeMake(2000, 1000);
    resultSize = CGSizeMake(800, 600);
    coef = [ MUImageScaling scaleCoefficientToResizeImageWithSize: originalSize toSize: resultSize ];
    
    XCTAssertEqualWithAccuracy(coef, 0.4f, accuracy, @" wrong koef ");
    
    originalSize = CGSizeMake(0, 0);
    resultSize = CGSizeMake(800, 600);
    coef = [ MUImageScaling scaleCoefficientToResizeImageWithSize: originalSize toSize: resultSize ];
    
    XCTAssertEqualWithAccuracy(coef, 1.f, accuracy, @" wrong koef ");
    
    originalSize = CGSizeMake(2000, 1000);
    resultSize = CGSizeMake(0, 0);
    coef = [ MUImageScaling scaleCoefficientToResizeImageWithSize: originalSize toSize: resultSize ];
    
    XCTAssertEqualWithAccuracy(coef, 0.f, accuracy, @" wrong koef ");
    
    originalSize = CGSizeMake(2000, 1000);
    resultSize = CGSizeMake(-800, -600);
    coef = [ MUImageScaling scaleCoefficientToResizeImageWithSize: originalSize toSize: resultSize ];
    
    XCTAssertEqualWithAccuracy(coef, 1.f, accuracy, @" wrong koef ");
    
    originalSize = CGSizeMake(-200, -1000);
    resultSize = CGSizeMake(800, 600);
    coef = [ MUImageScaling scaleCoefficientToResizeImageWithSize: originalSize toSize: resultSize ];
    
    XCTAssertEqualWithAccuracy(coef, 1.f, accuracy, @" wrong koef ");
}

@end
