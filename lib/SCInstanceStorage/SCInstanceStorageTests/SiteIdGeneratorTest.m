#import <XCTest/XCTest.h>

#import "SCSite.h"

@interface SiteIdGeneratorTest : XCTestCase

@end

@implementation SiteIdGeneratorTest

-(void)testSiteIdIsAlwaysDifferentForEmptySite
{
    SCSite* first  = [ SCSite emptySite ];
    SCSite* second = [ SCSite emptySite ];
    
    XCTAssertNotEqualObjects( first.siteId, second.siteId, @"Site id must be a unique UDID, generated during construction" );
}

-(void)testSiteIdIsAlwaysDifferentForSiteConstructor
{
    SCSite* first  = [ [ SCSite alloc ] initWithSiteUrl: @"http://localhost"
                                                   site: @"/sitecore/shell"
                     uploadFolderPathInsideMediaLibrary: @"/sitecore/media library"
                                               username: @"x"
                                               password: @"y"
                                      selectedForBrowse: NO
                                      selectedForUpload: NO ];
    
    SCSite* siteWithSameConstructor =
    [ [ SCSite alloc ] initWithSiteUrl: @"http://localhost"
                                  site: @"/sitecore/shell"
    uploadFolderPathInsideMediaLibrary: @"/sitecore/media library"
                              username: @"x"
                              password: @"y"
                     selectedForBrowse: NO
                     selectedForUpload: NO ];
    
    
    SCSite* second = siteWithSameConstructor;
    XCTAssertNotEqualObjects( first.siteId, second.siteId, @"Site id must be a unique UDID, generated during construction" );
}

-(void)testSiteIdIsSameAfterCopying
{
    SCSite* first  = [ [ SCSite alloc ] initWithSiteUrl: @"http://localhost"
                                                   site: @"/sitecore/shell"
                     uploadFolderPathInsideMediaLibrary: @"/sitecore/media library"
                                               username: @"x"
                                               password: @"y"
                                      selectedForBrowse: NO
                                      selectedForUpload: NO ];
    SCSite* second = [ first copy ];
    
    XCTAssertEqualObjects( first.siteId, second.siteId, @"site id not copied properly" );
    XCTAssertEqualObjects( first, second, @"copied object must be equal to the original one" );
    XCTAssertTrue( first != second, @"pointers must not be same for object copies" );
}

@end
