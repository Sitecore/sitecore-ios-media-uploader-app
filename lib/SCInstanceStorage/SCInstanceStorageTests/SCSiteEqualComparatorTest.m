#import <XCTest/XCTest.h>


#import "SCSite.h"
#import "SCSite+Mutable.h"

@interface SCSiteEqualComparatorTest : XCTestCase

@end



@implementation SCSiteEqualComparatorTest
{
    SCSite* _site;
}

-(void)setUp
{
    [ super setUp ];

    
    self->_site = [ [ SCSite alloc ] initWithSiteUrl: @"localhost"
                                                site: @"/sitecore/shell"
                  uploadFolderPathInsideMediaLibrary: @"/sitecore/media library"
                                            username: @"x"
                                            password: @"y"
                                   selectedForBrowse: NO
                                   selectedForUpload: NO ];
}

-(void)tearDown
{
    self->_site = nil;

    [ super tearDown ];
}

-(void)testSiteCopyIsEqualToTheOriginal
{
    SCSite* other = [ self->_site copy ];
    
    XCTAssertEqualObjects( other, self->_site, @"copy object must be equal" );
    XCTAssertTrue( self->_site != other, @"pointer of the copy must be different" );
}

-(void)testCapitalizedUrlIsStillEqual
{
    SCSite* other = [ self->_site copy ];
    other.siteUrl = @"LocalHOST";
    
    XCTAssertEqualObjects( other, self->_site, @"copy object must be equal" );
    XCTAssertTrue( self->_site != other, @"pointer of the copy must be different" );
}

-(void)testCapitalizedSiteIsStillEqual
{
    SCSite* other = [ self->_site copy ];
    other.site = @"/siteCore/SHELL";
    
    XCTAssertEqualObjects( other, self->_site, @"copy object must be equal" );
    XCTAssertTrue( self->_site != other, @"pointer of the copy must be different" );
}

-(void)testCapitalizedMediaFolderIsStillEqual_Default
{
    SCSite* other = [ self->_site copy ];
    other.uploadFolderPathInsideMediaLibrary = @"/Sitecore/Media libRARy";
    
    XCTAssertEqualObjects( other, self->_site, @"copy object must be equal" );
    XCTAssertTrue( self->_site != other, @"pointer of the copy must be different" );
}

-(void)testCapitalizedMediaFolderIsStillEqual_Custom
{
    self->_site.uploadFolderPathInsideMediaLibrary = @"xyz";
    
    SCSite* other = [ self->_site copy ];
    other.uploadFolderPathInsideMediaLibrary = @"XYz";
    
    XCTAssertEqualObjects( other, self->_site, @"copy object must be equal" );
    XCTAssertTrue( self->_site != other, @"pointer of the copy must be different" );
}

-(void)testUrl_Site_MediaPath_ChangeEquality
{
    {
        SCSite* other = [ self->_site copy ];
        other.siteUrl = @"bu";
        
        XCTAssertNotEqualObjects( other, self->_site, @"modified object must NOT be equal" );
        XCTAssertTrue( self->_site != other, @"pointer of the copy must be different" );
    }

    {
        SCSite* other = [ self->_site copy ];
        other.site = @"ra";
        
        XCTAssertNotEqualObjects( other, self->_site, @"copy object must be equal" );
        XCTAssertTrue( self->_site != other, @"pointer of the copy must be different" );

    }
    
    {
        SCSite* other = [ self->_site copy ];
        other.uploadFolderPathInsideMediaLibrary = @"ti";
        
        XCTAssertNotEqualObjects( other, self->_site, @"copy object must be equal" );
        XCTAssertTrue( self->_site != other, @"pointer of the copy must be different" );

    }
}

-(void)testOtherProperties_AreIgnoredBy_IsEqual
{
    {
        SCSite* other = [ self->_site copy ];
        other.username = @"abc";
        
        XCTAssertEqualObjects( other, self->_site, @"modified object must NOT be equal" );
        XCTAssertTrue( self->_site != other, @"pointer of the copy must be different" );
    }

    {
        SCSite* other = [ self->_site copy ];
        other.password = @"def";
        
        XCTAssertEqualObjects( other, self->_site, @"modified object must NOT be equal" );
        XCTAssertTrue( self->_site != other, @"pointer of the copy must be different" );
    }

    {
        SCSite* other = [ self->_site copy ];
        other.selectedForBrowse = YES;
        
        XCTAssertEqualObjects( other, self->_site, @"modified object must NOT be equal" );
        XCTAssertTrue( self->_site != other, @"pointer of the copy must be different" );
    }

    {
        SCSite* other = [ self->_site copy ];
        other.selectedForUpload = YES;
        
        XCTAssertEqualObjects( other, self->_site, @"modified object must NOT be equal" );
        XCTAssertTrue( self->_site != other, @"pointer of the copy must be different" );
    }
}

-(void)testSiteWithOtherIdIsStillEqual
{
    {
        SCSite* other = [ self->_site copy ];
        other.siteId = @"changed site id";
        
        XCTAssertEqualObjects( other, self->_site, @"modified object must NOT be equal" );
        XCTAssertTrue( self->_site != other, @"pointer of the copy must be different" );
    }
}


@end


