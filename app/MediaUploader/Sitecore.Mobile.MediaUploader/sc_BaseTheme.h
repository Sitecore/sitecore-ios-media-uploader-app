#import <Foundation/Foundation.h>
#import <UIKit/UIColor.h>


@interface sc_BaseTheme : NSObject

-(UIColor*)naviagtionBarBackgroundColor;
-(UIColor*)naviagtionBarTintColor;
-(UIColor*)normalRowBackgroundColor;
-(UIColor*)uploadedRowBackgroundColor;
-(UIColor*)errorRowBackgroundColor;
-(UIColor*)errorLabelColor;
-(UIColor*)labelBackgroundColor;
-(UIColor*)transparentLabelBackgroundColor;
-(UIColor*)disableSiteBackgroundColor;

-(UIImage*)uploadDoneIconImage;
-(UIImage*)uploadErrorIconImage;
-(UIImage*)uploadCanceledIconImage;
-(UIImage*)uploadReadyIconImage;
-(UIImage*)uploadInProgressIconImage;

@end
