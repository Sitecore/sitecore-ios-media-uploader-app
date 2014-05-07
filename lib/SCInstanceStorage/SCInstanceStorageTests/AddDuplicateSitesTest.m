#import <XCTest/XCTest.h>


#import "SCSitesManager.h"
#import "SCSitesManager+StoragePath.h"

#import "SCSite.h"


@interface AddDuplicateSitesTest : XCTestCase

@end


@implementation AddDuplicateSitesTest
{
    SCSitesManager* _storage;
    SCSite* _site;
    SCSite* _siteWithCapitalizedInstanceUrl;
}


-(void)cleanupStorageFile
{
    NSString* filePath = [ self->_storage getSitesFilePath ];
    [ [ NSFileManager defaultManager ] removeItemAtPath: filePath error: NULL ];
}
    
-(void)setUp
{
    [ super setUp ];
    
    self->_storage = [ [ SCSitesManager alloc ] initWithCacheFilesRootDirectory: @"/tmp" ];
    [ self cleanupStorageFile ];
    
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
    [ self cleanupStorageFile ];
    
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
        
        XCTAssertTrue( 1 == [ self->_storage sitesCount ], @"sitesCount mismatch" );
    }
    

    // add the same site
    {
        operationResult = NO;
        
        operationResult = [ self->_storage addSite: self->_site
                                             error: &error ];
        
        XCTAssertNil( error, @"Unexpected error" );
        XCTAssertTrue( operationResult, @"Unexpected error" );
        
        XCTAssertTrue( 2 == [ self->_storage sitesCount ], @"sitesCount mismatch" );
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
        
        XCTAssertTrue( 1 == [ self->_storage sitesCount ], @"sitesCount mismatch" );
    }
    
    
    // add a site with capitalized URL
    {
        operationResult = NO;
        
        operationResult = [ self->_storage addSite: self->_siteWithCapitalizedInstanceUrl
                                             error: &error ];
        
        XCTAssertNil( error, @"Unexpected error" );
        XCTAssertTrue( operationResult, @"Unexpected error" );
        
        XCTAssertTrue( 2 == [ self->_storage sitesCount ], @"sitesCount mismatch" );
    }
}

@end
