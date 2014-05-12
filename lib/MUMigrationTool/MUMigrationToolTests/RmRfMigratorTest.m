#import <XCTest/XCTest.h>
#import <MUMigrationTool/MUMigrationTool.h>


static NSString* const TMP_DIR_DOCUMENTS = @"/tmp/Documents";
static NSString* const TMP_Version_1_1_DIRECOTRY = @"/tmp/Documents/v1.1";



@interface RmRfMigratorTest : XCTestCase

@end




@implementation RmRfMigratorTest
{
    NSBundle* _legacyBundle;
    NSString* _legacyBundleRootPath;
    
    NSBundle* _v1Bundle;
    NSString* _v1BundleRootPath;
    
    NSBundle* _mainBundle;
    
    NSFileManager* _fm;
    MUMigrationStrategyFactory* _factory;
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
    
    self->_factory = [ [ MUMigrationStrategyFactory alloc ] initWithFileManager: self->_fm
                                                             rootCacheDirectory: TMP_DIR_DOCUMENTS ];
    
    [ self cleanupFS ];
    [ self createFS ];
}

-(void)tearDown
{
    [ self cleanupFS ];
    
    self->_fm                   = nil;
    self->_mainBundle           = nil;
    self->_legacyBundle         = nil;
    self->_legacyBundleRootPath = nil;
    self->_v1Bundle             = nil;
    self->_v1BundleRootPath     = nil;
    
    [ super tearDown ];
}

-(void)createFS
{
    NSError* fmError = nil;
    BOOL fmResult = NO;
    NSString* srcPath = nil;

    
    fmResult = [ self->_fm createDirectoryAtPath: TMP_Version_1_1_DIRECOTRY
                     withIntermediateDirectories: YES
                                      attributes: nil
                                           error: &fmError ];
    
    
    srcPath = [ self->_legacyBundleRootPath stringByAppendingPathComponent: @"sites.txt" ];
    fmResult = [ self->_fm copyItemAtPath: srcPath
                                   toPath: @"/tmp/Documents/sites.txt"
                                    error: &fmError ];
    
    
    srcPath = [ self->_v1BundleRootPath stringByAppendingPathComponent: @"SCSitesStorage.dat" ];
    fmResult = [ self->_fm copyItemAtPath: srcPath
                                   toPath: @"/tmp/Documents/v1.1/SCSitesStorage.dat"
                                    error: &fmError ];
    
    
    
    srcPath = [ self->_legacyBundleRootPath stringByAppendingPathComponent: @"sites.txt" ];
    fmResult = [ self->_fm copyItemAtPath: srcPath
                                   toPath: @"/tmp/Documents/sites.txt"
                                    error: &fmError ];
}


-(void)cleanupFS
{
    NSError* fmError = nil;
    BOOL fmResult = NO;
    
    fmResult = [ self->_fm removeItemAtPath: TMP_DIR_DOCUMENTS
                                      error: &fmError ];
}



-(void)testRmRfStrategyRemovesAllFilesFromDocumentsDirectory
{
    NSError* error = nil;
    BOOL result;
    MUApplicationVersion version;

    MUVersionDetector* detector = [ [ MUVersionDetector alloc ] initWithFileManager: self->_fm
                                                                 rootCacheDirectory: TMP_DIR_DOCUMENTS ];
    version = [ detector applicationVersionBeforeCurrentLaunch ];
    XCTAssertTrue( MUVVersion_1_0 == version, @"Wrong version detected" );
    
    id<MUMigrationStrategy> migrator = [ self->_factory removeOldDataStrategy ];
    result = [ migrator migrateMediaUploaderAppFromVersion: MUVVersion_1_0
                                                 toVersion: MUVVersion_1_1
                                                     error: &error ];
    
    XCTAssertNil( error, @"migration error occured" );
    XCTAssertTrue( result, @"migration error occured" );



    version = [ detector applicationVersionBeforeCurrentLaunch ];
    XCTAssertTrue( MUVUnknown == version, @"Wrong version after migration" );
}


-(void)testMigratorRemovesAllFilesFromDocumentsDirectory
{
    NSError* error = nil;
    BOOL result;
    MUApplicationVersion version;
    
    MUVersionDetector* detector = [ [ MUVersionDetector alloc ] initWithFileManager: self->_fm
                                                                 rootCacheDirectory: TMP_DIR_DOCUMENTS ];
    version = [ detector applicationVersionBeforeCurrentLaunch ];
    XCTAssertTrue( MUVVersion_1_0 == version, @"Wrong version detected" );
    
    
    MUApplicationMigrator* migrator = [ [ MUApplicationMigrator alloc ] initWithFileManager: self->_fm
                                                                         rootCacheDirectory: TMP_DIR_DOCUMENTS ];
    result = [ migrator migrateUploaderAppWithError: &error ];
    
    
    XCTAssertNil( error, @"migration error occured" );
    XCTAssertTrue( result, @"migration error occured" );
    
    
    
    version = [ detector applicationVersionBeforeCurrentLaunch ];
    XCTAssertTrue( MUVUnknown == version, @"Wrong version after migration" );
}


@end
