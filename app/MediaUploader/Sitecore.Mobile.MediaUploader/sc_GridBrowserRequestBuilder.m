#import "sc_GridBrowserRequestBuilder.h"

@implementation sc_GridBrowserRequestBuilder

//FIXME: bug in Mobile SDK, chache wasn't updated after force refresh. Must be fixed in mobile SDK.
-(SCReadItemsRequest*)itemsBrowser:(id)sender
           levelDownRequestForItem:(SCItem*)item
{

    SCReadItemsRequest* request = [ super itemsBrowser: sender levelDownRequestForItem: item ];
    request.flags = SCReadItemRequestIngnoreCache;
    
    return request;
}

@end
