//
//  PNBatchedSubscribeTests.m
//  PubNub Tests
//
//  Created by Jordan Zucker on 6/22/15.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <PubNub/PubNub.h>

#import "PNBasicSubscribeTestCase.h"

@interface PNBatchedSubscribeTests : PNBasicSubscribeTestCase
@end

@implementation PNBatchedSubscribeTests

- (BOOL)isRecording {
    return YES;
}

- (void)testBatchedSubscribes {
    self.subscribeExpectation = [self expectationWithDescription:@"network"];
    [self.client subscribeToChannels:@[@"a", @"b"] withPresence:YES];
    [self.client subscribeToChannels:@[@"c"] withPresence:NO];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
            XCTFail(@"what went wrong?");
        }
    }];
}

#pragma mark - PNObjectEventListener

- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult *)message withStatus:(PNErrorStatus *)status {
    XCTAssertNil(status);
    XCTAssertEqualObjects(self.client, client);
    XCTAssertEqualObjects(client.uuid, message.uuid);
    XCTAssertNotNil(message.uuid);
    XCTAssertNil(message.authKey);
    XCTAssertEqual(message.statusCode, 200);
    XCTAssertTrue(message.TLSEnabled);
    XCTAssertEqual(message.operation, PNSubscribeOperation);
    NSLog(@"message:");
    NSLog(@"%@", message.data.message);
    XCTAssertEqualObjects(message.data.message, @"*************** 5849 - 2015-06-17 15:19:49");
    [self.subscribeExpectation fulfill];
}

- (void)client:(PubNub *)client didReceivePresenceEvent:(PNPresenceEventResult *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)client:(PubNub *)client didReceiveStatus:(PNSubscribeStatus *)status {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
