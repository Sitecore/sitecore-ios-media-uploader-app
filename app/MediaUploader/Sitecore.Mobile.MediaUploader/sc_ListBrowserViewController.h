#import <UIKit/UIKit.h>

typedef void (^SCUPloadFolderReceived)(NSString* folder);


@interface sc_ListBrowserViewController : UIViewController

-(void)chooseUploaderFolderForSite:(SCSite*)site
                       witCallback:(SCUPloadFolderReceived)callback;

@end
