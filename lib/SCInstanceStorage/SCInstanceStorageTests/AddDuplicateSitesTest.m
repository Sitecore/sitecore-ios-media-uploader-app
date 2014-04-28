#import <XCTest/XCTest.h>


#import "SCSitesManager.h"
#import "SCSite.h"


@interface AddDuplicateSitesTest : XCTestCase

@end


@implementation AddDuplicateSitesTest
{
    SCSitesManager* _storage;
    SCSite* _site;
    SCSite* _siteWithCapitalizedInstanceUrl;
}

-(void)setUp
{
    [ super setUp ];
    
    self->_storage = [ SCSitesManager new ];
    
    self->_site = [ [ SCSite alloc ] initWithSiteUrl: @"http://localhost"
                                                site: @"/sitecore/shell"
                  uploadFolderPathInsideMediaLibrary: @"/sitecore/media library"
                                            username: @"x"
                                            password: @"y"
                                   selectedForBrowse: NO
                                   selectedForUpload: NO ];
    
    
    self->_siteWithCapitalizedInstanceUrl = [ [ SCSite alloc ] initWithSiteUrl: @"HTTP://LOCALHOST"
                                                                          site: @"/sitecore/shell"
                                            uploadFolderPathInsideMediaLibrary: @"/sitecore/media library"
                                                                      username: @"x"
                                                                      password: @"y"
                                                             selectedForBrowse: NO
                                                             selectedForUpload: NO ];
}

-(void)tearDown
{
    self->_storage = nil;
    self->_site = nil;
    self->_siteWithCapitalizedInstanceUrl = nil;

    [ super tearDown ];
}

-(void)testDuplicateSitesCanBeAdded
{
    NSError* error = nil;
    BOOL operationResult = NO;
    
    
    // add site
    {
        operationResult = NO;
        
        operationResult = [ self->_storage addSite: self->_site
                                             error: &error ];
        
        XCTAssertNil( error, @"Unexpected error" );
        XCTAssertTrue( operationResult, @"Unexpected error" );
    }
    

    // add the same site
    {
        operationResult = NO;
        
        operationResult = [ self->_storage addSite: self->_site
                                             error: &error ];
        
        XCTAssertNil( error, @"Unexpected error" );
        XCTAssertTrue( operationResult, @"Unexpected error" );
    }
}

-(void)testCapitalizedInstanceUrlCanBeAdded
{
    NSError* error = nil;
    BOOL operationResult = NO;
    
    
    // add site
    {
        operationResult = NO;
        
        operationResult = [ self->_storage addSite: self->_site
                                             error: &error ];
        
        XCTAssertNil( error, @"Unexpected error" );
        XCTAssertTrue( operationResult, @"Unexpected error" );
    }
    
    
    // add a site with capitalized URL
    {
        operationResult = NO;
        
        operationResult = [ self->_storage addSite: self->_siteWithCapitalizedInstanceUrl
                                             error: &error ];
        
        XCTAssertNil( error, @"Unexpected error" );
        XCTAssertTrue( operationResult, @"Unexpected error" );
    }
}

@end
