#import <XCTest/XCTest.h>


#import "SCSite.h"


@interface SCSiteEqualComparatorTest : XCTestCase

@end



@implementation SCSiteEqualComparatorTest
{
    SCSite* _site;
    SCSite* _siteWithCapitalizedInstanceUrl;
}

-(void)setUp
{
    [ super setUp ];

    
    self->_site = [ [ SCSite alloc ] initWithSiteUrl: @"http://localhost"
                                                site: @"/sitecore/shell"
                  uploadFolderPathInsideMediaLibrary: @"/sitecore/media library"
                                            username: @"x"
                                            password: @"y"
                                   selectedForBrowse: NO
                                   selectedForUpload: NO ];
    
    
    self->_siteWithCapitalizedInstanceUrl = [ [ SCSite alloc ] initWithSiteUrl: @"HTTP://LOCALHOST"
                                                                          site: @"/SITECORE/SHELL"
                                            uploadFolderPathInsideMediaLibrary: @"/SITECORE/MEDIA LIBRARY"
                                                                      username: @"x"
                                                                      password: @"y"
                                                             selectedForBrowse: NO
                                                             selectedForUpload: NO ];
}

-(void)tearDown
{
    self->_site = nil;
    self->_siteWithCapitalizedInstanceUrl = nil;

    [ super tearDown ];
}

-(void)testSiteCopyIsEqualToTheOriginal
{
    SCSite* other = [ self->_site copy ];
    
    XCTAssertEqualObjects( other, self->_site, @"copy object must be equal" );
    XCTAssertTrue( self->_site != other, @"pointer of the copy must be different" );
}

@end


