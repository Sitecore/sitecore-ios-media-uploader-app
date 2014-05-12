#import <XCTest/XCTest.h>
#import <MUMigrationTool/MUMigrationTool.h>


@interface VersionDetectorTest : XCTestCase

@end


@implementation VersionDetectorTest
{
    NSBundle* _legacyBundle;
    NSString* _legacyBundleRootPath;
    
    NSBundle* _v1Bundle;
    NSString* _v1BundleRootPath;
    
    NSBundle* _mainBundle;
    
    NSFileManager* _fm;
}


-(void)setUp
{
    [ super setUp ];
    
    self->_fm = [ NSFileManager defaultManager ];
    self->_mainBundle = [ NSBundle bundleForClass: [ self class ] ];
    
    {
        self->_legacyBundleRootPath = [ self->_mainBundle pathForResource: @"LegacyDocumentsDir"
                                                                   ofType: @"bundle"];
        self->_legacyBundle = [ NSBundle bundleWithPath: self->_legacyBundleRootPath ];
    }
    
    {
        self->_v1BundleRootPath  = [ self->_mainBundle pathForResource: @"V1DocumentsDir"
                                                                ofType: @"bundle"];
        self->_v1Bundle = [ NSBundle bundleWithPath: self->_v1BundleRootPath ];
    }
}

-(void)tearDown
{
    self->_fm                   = nil;
    self->_mainBundle           = nil;
    self->_legacyBundle         = nil;
    self->_legacyBundleRootPath = nil;
    self->_v1Bundle             = nil;
    self->_v1BundleRootPath     = nil;

    [ super tearDown ];
}

-(void)testVersion1_1_ReleaseIsLatest
{
    XCTAssertTrue( MUVLatestRelease == MUVVersion_1_1, @"latest release mismatch" );
}

-(void)testVersion1_0_ReleaseIsFirst
{
    XCTAssertTrue( MUVFirstRelease == MUVVersion_1_0, @"latest release mismatch" );
}


-(void)testLegacyFilesInRootAreDetectedAsV1
{
    MUVersionDetector* detector = [ [ MUVersionDetector alloc ] initWithFileManager: self->_fm
                                                                 rootCacheDirectory: self->_legacyBundleRootPath ];
    
    MUApplicationVersion result = [ detector applicationVersionBeforeCurrentLaunch ];
    
    XCTAssertTrue( MUVFirstRelease == result, @"Wrong version detected" );
}

-(void)testV1FilesInRootAreDetectedAsUnknown
{
    MUVersionDetector* detector = [ [ MUVersionDetector alloc ] initWithFileManager: self->_fm
                                                                 rootCacheDirectory: self->_v1BundleRootPath ];
    
    MUApplicationVersion result = [ detector applicationVersionBeforeCurrentLaunch ];
    
    XCTAssertTrue( MUVUnknown == result, @"Wrong version detected" );
}


//static NSString* const TMP_DIR = @"/tmp";
static NSString* const TMP_DIR_DOCUMENTS = @"/tmp/Documents";
static NSString* const TMP_Version_1_1_DIRECOTRY = @"/tmp/Documents/v1.1";

-(void)testV1FilesInFolderAreDetectedAsV1
{
    MUApplicationVersion result;
    
    NSError* fmError = nil;
    BOOL fmResult = NO;
    NSString* srcPath = nil;
    
    {
        fmResult = [ self->_fm createDirectoryAtPath: TMP_Version_1_1_DIRECOTRY
                         withIntermediateDirectories: YES
                                          attributes: nil
                                               error: &fmError ];

        XCTAssertNil( fmError, @"environment setup error" );
        XCTAssertTrue( fmResult, @"environment setup error" );
        
        
        
        srcPath = [ self->_v1BundleRootPath stringByAppendingPathComponent: @"SCSitesStorage.dat" ];
        fmResult = [ self->_fm copyItemAtPath: srcPath
                                       toPath: @"/tmp/Documents/v1.1/SCSitesStorage.dat"
                                        error: &fmError ];
        XCTAssertNil( fmError, @"environment setup error" );
        XCTAssertTrue( fmResult, @"environment setup error" );
        

    }

    
    MUVersionDetector* detector = [ [ MUVersionDetector alloc ] initWithFileManager: self->_fm
                                                                 rootCacheDirectory: TMP_DIR_DOCUMENTS ];
    result = [ detector applicationVersionBeforeCurrentLaunch ];
    XCTAssertTrue( MUVVersion_1_1 == result, @"Wrong version detected" );
    
    
    {
        fmResult = [ self->_fm removeItemAtPath: TMP_DIR_DOCUMENTS
                                          error: &fmError ];
        XCTAssertNil( fmError, @"environment setup error" );
        XCTAssertTrue( fmResult, @"environment setup error" );
    }
}

-(void)testLegacyVersionHasHigherPriority
{
    MUApplicationVersion result;
    
    NSError* fmError = nil;
    BOOL fmResult = NO;
    NSString* srcPath = nil;
    
    {
        fmResult = [ self->_fm createDirectoryAtPath: TMP_Version_1_1_DIRECOTRY
                         withIntermediateDirectories: YES
                                          attributes: nil
                                               error: &fmError ];
        
        XCTAssertNil( fmError, @"environment setup error" );
        XCTAssertTrue( fmResult, @"environment setup error" );
        
        
        
        srcPath = [ self->_v1BundleRootPath stringByAppendingPathComponent: @"SCSitesStorage.dat" ];
        fmResult = [ self->_fm copyItemAtPath: srcPath
                                       toPath: @"/tmp/Documents/v1.1/SCSitesStorage.dat"
                                        error: &fmError ];
        XCTAssertNil( fmError, @"environment setup error" );
        XCTAssertTrue( fmResult, @"environment setup error" );

        
        
        srcPath = [ self->_legacyBundleRootPath stringByAppendingPathComponent: @"sites.txt" ];
        fmResult = [ self->_fm copyItemAtPath: srcPath
                                       toPath: @"/tmp/Documents/sites.txt"
                                        error: &fmError ];
        XCTAssertNil( fmError, @"environment setup error" );
        XCTAssertTrue( fmResult, @"environment setup error" );

        
    }
    
    
    MUVersionDetector* detector = [ [ MUVersionDetector alloc ] initWithFileManager: self->_fm
                                                                 rootCacheDirectory: TMP_DIR_DOCUMENTS ];
    result = [ detector applicationVersionBeforeCurrentLaunch ];
    XCTAssertTrue( MUVVersion_1_0 == result, @"Wrong version detected" );
    
    
    {
        fmResult = [ self->_fm removeItemAtPath: TMP_DIR_DOCUMENTS
                                          error: &fmError ];
        XCTAssertNil( fmError, @"environment setup error" );
        XCTAssertTrue( fmResult, @"environment setup error" );
    }
}

@end
