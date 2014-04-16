#import <Foundation/Foundation.h>

@interface sc_ListBrowserCellFactory : NSObject<SIBListModeCellFactory>

@property (strong, nonatomic) IBOutlet SCItemListBrowser* itemsBrowserController;

@end
