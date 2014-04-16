#import <Foundation/Foundation.h>


@interface sc_BrowseViewCellFactory : NSObject<SIBGridModeCellFactory>

@property (strong, nonatomic) IBOutlet SCItemGridBrowser* itemsBrowserController;

@end
