#import <XCTest/XCTest.h>

#import "SCSitesManager.h"
#import "SCSitesManager+StoragePath.h"

#import "SCSite.h"


@interface SelectForEditingTest : XCTestCase

@end

@implementation SelectForEditingTest
{
    SCSitesManager* _storage;
    SCSite* _site           ;
    SCSite* _sameSite       ;
    SCSite* _anotherSameSite;
    SCSite* _differentSite  ;
}


-(void)cleanupStorageFile
{
    NSString* filePath = [ self->_storage getSitesFilePath ];
    [ [ NSFileManager defaultManager ] removeItemAtPath: filePath error: NULL ];
}

-(void)setUp
{
    [ super setUp ];
    
    self->_storage = [ SCSitesManager new ];
    [ self cleanupStorageFile ];
    
    self->_site = [ [ SCSite alloc ] initWithSiteUrl: @"http://localhost"
                                                site: @"/sitecore/shell"
                  uploadFolderPathInsideMediaLibrary: @"/sitecore/media library"
                                            username: @"x"
                                            password: @"y"
                                   selectedForBrowse: NO
                                   selectedForUpload: NO ];
    
    
    self->_sameSite = [ [ SCSite alloc ] initWithSiteUrl: @"http://localhost"
                                                    site: @"/sitecore/shell"
                      uploadFolderPathInsideMediaLibrary: @"/sitecore/media library"
                                                username: @"x"
                                                password: @"y"
                                       selectedForBrowse: NO
                                       selectedForUpload: NO ];
    
    
    self->_anotherSameSite = [ [ SCSite alloc ] initWithSiteUrl: @"http://localhost"
                                                           site: @"/sitecore/shell"
                             uploadFolderPathInsideMediaLibrary: @"/sitecore/media library"
                                                       username: @"x"
                                                       password: @"y"
                                              selectedForBrowse: NO
                                              selectedForUpload: NO ];
    
    
    self->_differentSite = [ [ SCSite alloc ] initWithSiteUrl: @"http://localhost"
                                                         site: @""
                           uploadFolderPathInsideMediaLibrary: @"/sitecore/media library/123xyz"
                                                     username: @"abc"
                                                     password: @"def"
                                            selectedForBrowse: NO
                                            selectedForUpload: NO ];
    
    NSError* error = nil;
    [ self->_storage addSite: self->_site
                       error: &error ];

    [ self->_storage addSite: self->_differentSite
                       error: &error ];

    
    [ self->_storage addSite: self->_sameSite
                       error: &error ];
    
    
//    [ self->_storage addSite: self->_anotherSameSite
//                       error: &error ];
}

-(void)tearDown
{
    [ self cleanupStorageFile ];
    self->_storage = nil;
    
    self->_site = nil;
    self->_sameSite = nil;
    self->_anotherSameSite = nil;
    
    [ super tearDown ];
}

-(void)testEditingSelectionAppliesToSiteWithSameId
{
    NSError* error = nil;
    BOOL opResult = NO;
    SCSite* selectedSite = nil;
    
    selectedSite = self->_storage.siteForUpload;
    XCTAssertEqualObjects( selectedSite.siteId, self->_site.siteId, @"first added site must be selected by default" );
    
    
    
    opResult = [ self->_storage setSiteForUpload: self->_sameSite
                                           error: &error];
    XCTAssertTrue( opResult, @"site should be set successfully" );
    
    
    selectedSite = self->_storage.siteForUpload;
    XCTAssertEqualObjects( selectedSite.siteId, self->_sameSite.siteId, @"first added site must be selected by default" );
    
    NSArray* internalSitesList = [ self->_storage sitesList ];
    XCTAssertFalse( [ internalSitesList[0] selectedForUpload ], @"first site must not be selected" );
    XCTAssertFalse( [ internalSitesList[1] selectedForUpload ], @"different site must not be selected" );
    XCTAssertTrue ( [ internalSitesList[2] selectedForUpload ], @"'same site' must be selected" );
}

@end
