//
//  MUMediaItemTest.m
//  MUUploadManager
//
//  Created by Igor on 29/04/14.
//  Copyright (c) 2014 Sitecore. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MUMedia.h"

@interface MUMediaItemTest : XCTestCase

@end

@implementation MUMediaItemTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitConstructorIsNotAvailable
{
    XCTAssertThrows([[MUMedia alloc] init], @"init is not available");
}

-(void)testNewItemWithNilFieldsAvailable
{
    MUMedia *item = [[MUMedia alloc] initWithName:nil
                                        dateTime:nil
                                    locationInfo:nil
                                        videoUrl:nil
                                        imageUrl:nil
                                       thumbnail:nil];
    XCTAssertTrue(item != nil, @"item should be created");
}

-(void)testuploadStatusByDefault
{
    MUMedia *item = [[MUMedia alloc] initWithName:nil
                                         dateTime:nil
                                     locationInfo:nil
                                         videoUrl:nil
                                         imageUrl:nil
                                        thumbnail:nil];
    XCTAssertTrue(item.uploadStatusData.statusId == READY_FOR_UPLOAD, @"item should be created");
}

-(void)testVideoItemDetected
{
    MUMedia *item = [[MUMedia alloc] initWithName:nil
                                         dateTime:nil
                                     locationInfo:nil
                                         videoUrl:[[NSURL alloc] initFileURLWithPath:@"some/path"]
                                         imageUrl:nil
                                        thumbnail:nil];
    XCTAssertTrue(item.isVideo, @"item should be created");
}

-(void)testImageItemDetected
{
    MUMedia *item = [[MUMedia alloc] initWithName:nil
                                         dateTime:nil
                                     locationInfo:nil
                                         videoUrl:nil
                                         imageUrl:[[NSURL alloc] initFileURLWithPath:@"some/path"]
                                        thumbnail:nil];
    XCTAssertTrue(item.isImage, @"item should be created");
}

-(void)testItemSwitchBetweenImageandVideoCorrectly
{
    MUMedia *item = [[MUMedia alloc] initWithName:nil
                                         dateTime:nil
                                     locationInfo:nil
                                         videoUrl:nil
                                         imageUrl:[[NSURL alloc] initFileURLWithPath:@"some/path"]
                                        thumbnail:nil];
    
    item.videoUrl = [[NSURL alloc] initFileURLWithPath:@"some/path"];
    XCTAssertFalse(item.isImage, @"item should be created");
    XCTAssertTrue(item.isVideo, @"item should be created");
}


@end
