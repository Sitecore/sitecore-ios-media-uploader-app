#import <UIKit/UIKit.h>
#import "sc_Site.h"

typedef void (^SCUPloadFolderReceived)(NSString* folder);

@interface sc_ListBrowserViewController : UIViewController

-(void)chooseUploaderFolderForSite:(sc_Site*)site witCallback:(SCUPloadFolderReceived)callback;

@end
