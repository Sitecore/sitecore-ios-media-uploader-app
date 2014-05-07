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
    manager = [ [ MUItemsForUploadManager alloc ] initWithCacheFilesRootDirectory: @"/tmp" ];
}

- (void)tearDown
{
    [super tearDown];
    [ self deleteFileStorage ];
}

-(void)deleteFileStorage
{
    NSString* appFile = @"/tmp/mediaUpload.dat";
    
    [ [ NSFileManager defaultManager ] removeItemAtPath: appFile
                                                  error: NULL ];
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
    
    MUItemsForUploadManager *newmanager = [ [ MUItemsForUploadManager alloc ] initWithCacheFilesRootDirectory: @"/tmp" ];
    
    XCTAssertTrue([newmanager uploadCount] == 1, @"element should be added");
    XCTAssertTrue([[newmanager mediaUploadAtIndex:0].name isEqualToString:@"test"], @"element should be the same");
}

- (void)testItemsRemoving
{
    MUMedia *elem = [[MUMedia alloc] initWithName:@"test"
                                         dateTime:nil
                                     locationInfo:nil
                                         videoUrl:nil
                                         imageUrl:nil
                                        thumbnail:nil];
    [manager addMediaUpload:elem];
    
    XCTAssertTrue([manager uploadCount] == 1, @"element should be added");
    XCTAssertTrue([[manager mediaUploadAtIndex:0].name isEqualToString:@"test"], @"element should be the same");
    
    [manager removeMediaUploadAtIndex:0 error:NULL];
    XCTAssertTrue([manager uploadCount] == 0, @"element should be removed");
}

- (void)testItemsRemovingShouldCrashIfIndexIsOutOfRange
{
    MUMedia *elem = [[MUMedia alloc] initWithName:@"test"
                                         dateTime:nil
                                     locationInfo:nil
                                         videoUrl:nil
                                         imageUrl:nil
                                        thumbnail:nil];
    [manager addMediaUpload:elem];
    
    XCTAssertTrue([manager uploadCount] == 1, @"element should be added");
    XCTAssertTrue([[manager mediaUploadAtIndex:0].name isEqualToString:@"test"], @"element should be the same");
    
    XCTAssertThrows([manager removeMediaUploadAtIndex:1 error:NULL], @"index is out of range");
}

- (void)testItemsGetterShouldCrashIfIndexIsOutOfRange
{
    MUMedia *elem = [[MUMedia alloc] initWithName:@"test"
                                         dateTime:nil
                                     locationInfo:nil
                                         videoUrl:nil
                                         imageUrl:nil
                                        thumbnail:nil];
    [manager addMediaUpload:elem];
    
    XCTAssertTrue([manager uploadCount] == 1, @"element should be added");
    XCTAssertTrue([[manager mediaUploadAtIndex:0].name isEqualToString:@"test"], @"element should be the same");
    
    XCTAssertThrows([manager mediaUploadAtIndex: 1], @"index is out of range");
}

- (void)testSetUploadItemStatusWorks
{
    MUMedia *elem = [[MUMedia alloc] initWithName:@"test"
                                         dateTime:nil
                                     locationInfo:nil
                                         videoUrl:nil
                                         imageUrl:nil
                                        thumbnail:nil];
    [manager addMediaUpload:elem];
    
    [manager setUploadStatus: UPLOAD_CANCELED
             withDescription: @"upload was canceled"
       forMediaUploadAtIndex: 0];
    
     XCTAssertTrue(elem.uploadStatusData.statusId == UPLOAD_CANCELED, @"status should be 'canceled'");
}

- (void)testSetUploadItemStatusShouldCrashIfIndexIsOutOfRange
{
    MUMedia *elem = [[MUMedia alloc] initWithName:@"test"
                                         dateTime:nil
                                     locationInfo:nil
                                         videoUrl:nil
                                         imageUrl:nil
                                        thumbnail:nil];
    [manager addMediaUpload:elem];
    
    
    XCTAssertThrows([manager setUploadStatus: UPLOAD_CANCELED
                             withDescription: @"upload was canceled"
                       forMediaUploadAtIndex: 1], @"index is out of range");
}

- (void)testSetUploadItemStatusWorksWithPersistentStorage
{
    MUMedia *elem = [[MUMedia alloc] initWithName:@"test"
                                         dateTime:nil
                                     locationInfo:nil
                                         videoUrl:nil
                                         imageUrl:nil
                                        thumbnail:nil];
    [manager addMediaUpload:elem];
    
    MUItemsForUploadManager *newmanager = [ [ MUItemsForUploadManager alloc ] initWithCacheFilesRootDirectory: @"/tmp" ];
    
    [newmanager setUploadStatus: UPLOAD_CANCELED
                withDescription: @"upload was canceled"
          forMediaUploadAtIndex: 0];
    MUMedia *newElem = [ newmanager mediaUploadAtIndex: 0 ];
    XCTAssertTrue(newElem.uploadStatusData.statusId == UPLOAD_CANCELED, @"status should be 'canceled'");
}

- (void)testFilteringTesting
{
    MUMedia *elem = [[MUMedia alloc] initWithName:@"test"
                                         dateTime:nil
                                     locationInfo:nil
                                         videoUrl:nil
                                         imageUrl:nil
                                        thumbnail:nil];
    [manager addMediaUpload:elem];
    
    elem = [[MUMedia alloc] initWithName:@"test"
                                dateTime:nil
                            locationInfo:nil
                                videoUrl:nil
                                imageUrl:nil
                               thumbnail:nil];
    [manager addMediaUpload:elem];
    
    [manager setUploadStatus: UPLOAD_ERROR
             withDescription: @"some error"
       forMediaUploadAtIndex: 0];
    
    [manager setUploadStatus: UPLOAD_DONE
             withDescription: @"some error"
       forMediaUploadAtIndex: 1];
    
    [manager setFilterOption:SHOW_ALL_ITEMS];
    XCTAssertTrue(manager.uploadCount == 2, @"all - 2 items");
   
    [manager setFilterOption:SHOW_COMLETED_ITEMS];
    XCTAssertTrue(manager.uploadCount == 1, @"completes - 1 item");
    XCTAssertTrue([manager mediaUploadAtIndex:0].uploadStatusData.statusId == UPLOAD_DONE, @"status is correct");
    
    [manager setFilterOption:SHOW_NOT_COMLETED_ITEMS];
    XCTAssertTrue(manager.uploadCount == 1, @"completes - 1 item");
    XCTAssertTrue([manager mediaUploadAtIndex:0].uploadStatusData.statusId == UPLOAD_ERROR, @"status is correct");
}


@end
