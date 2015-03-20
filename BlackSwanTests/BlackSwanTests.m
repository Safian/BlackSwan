//
//  BlackSwanTests.m
//  BlackSwanTests
//
//  Created by Safian Szabolcs on 08/03/15.
//  Copyright (c) 2015 safian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NetworkManager.h"
#import "RSSManager.h"

@interface BlackSwanTests : XCTestCase

@end

@implementation BlackSwanTests

- (void)setUp {
    [super setUp];
     NSLog(@"%@ setUp", self.name);
}

- (void)tearDown {
    [super tearDown];
}

- (void)testDowloadRandomCatImage {
    
    NSLog(@"%@ testDowloadRandomCatImage", self.name);
    __block BOOL waitingForBlock = YES;
    [[NetworkManager sharedInstance] dowloadRandomCatImageCompletion:^(UIImage *image) {
        XCTAssertNotNil(image, @"Cannot download the image");
        waitingForBlock = NO;
    }];
    // Run the loop
    while(waitingForBlock) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

- (void)testRSSManager {
    
    NSLog(@"%@ testRSSManager", self.name);
    
    __block BOOL waitingForBlock = YES;
    [[RSSManager sharedInstance] dowloadRSSItems:^(NSArray *rssItems) {
        XCTAssertNotNil(rssItems, @"Cannot download the rss data");
        waitingForBlock = NO;
        NSLog(@"rssItems: %@", rssItems);
    }];
    // Run the loop
    while(waitingForBlock) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

@end
