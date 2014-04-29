//
//  MUUploadManagerTests.m
//  MUUploadManagerTests
//
//  Created by Igor on 23/04/14.
//  Copyright (c) 2014 Sitecore. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MUItemsForUploadManager.h"
#import "MUMedia.h"

@interface MUUploadManagerTests : XCTestCase

@end

@implementation MUUploadManagerTests
{
    MUItemsForUploadManager* manager;
}

- (void)setUp
{
    [super setUp];
    [ self deleteFileStorage ];
    manager = [MUItemsForUploadManager new];
}

- (void)tearDown
{
    [super tearDown];
    [ self deleteFileStorage ];
}

-(void)deleteFileStorage
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString* documentsDirectory = [ paths objectAtIndex: 0 ];
    NSString* appFile = [ documentsDirectory stringByAppendingPathComponent: @"mediaUpload.dat" ];
    
    [[NSFileManager defaultManager] removeItemAtPath:appFile error:nil];
}

- (void)testOnlyMUMediaCanBeAdded
{
    NSString *elem = @"";
    XCTAssertThrows([manager addMediaUpload:(MUMedia *)elem], @"element must be MUMedia member");
}

- (void)testElementMustNotBeNil
{
    XCTAssertThrows([manager addMediaUpload:nil], @"element must not be nil");
}

- (void)testCorrectElementAddedSuccessfuly
{
    MUMedia *elem = [[MUMedia alloc] initWithName:@"test"
                                         dateTime:nil
                                     locationInfo:nil
                                         videoUrl:nil
                                         imageUrl:nil
                                        thumbnail:nil];
    [manager addMediaUpload:elem];
    
    XCTAssertTrue([manager uploadCount] == 1, @"element should be added");
    XCTAssertTrue([manager mediaUploadAtIndex:0] == elem, @"element should be the same");
}

- (void)testPersistentStorage
{
    MUMedia *elem = [[MUMedia alloc] initWithName:@"test"
                                         dateTime:nil
                                     locationInfo:nil
                                         videoUrl:nil
                                         imageUrl:nil
                                        thumbnail:nil];
    [manager addMediaUpload:elem];
    
    MUItemsForUploadManager *newmanager = [MUItemsForUploadManager new];
    
    XCTAssertTrue([newmanager uploadCount] == 1, @"element should be added");
    XCTAssertTrue([[newmanager mediaUploadAtIndex:0].name isEqualToString:@"test"], @"element should be the same");
}



@end
