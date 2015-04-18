//
//  YLProgressBarSample_Tests.m
//  YLProgressBarSample Tests
//
//  Created by Diogo on 4/18/15.
//  Copyright (c) 2015 Yannick Loriot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLProgressBar.h"
#import <FBSnapshotTestCase.h>

static CGRect const kTestBarRect = (CGRect) { 0, 0, 300, 10};

@interface YLProgressBarSample_Tests : FBSnapshotTestCase

@end

@implementation YLProgressBarSample_Tests
{
    YLProgressBar *bar;
}

- (void)setUp
{
    [super setUp];

//    self.recordMode = YES;
    bar = [[YLProgressBar alloc] initWithFrame:kTestBarRect];
}

- (void)tearDown
{
    bar = nil;

    [super tearDown];
}

#pragma mark - Logic tests

- (void)testInitializable
{
    XCTAssertNotNil(bar, @"Bar should be initialized");
}

- (void)testDefaultPropertiesValues
{
    XCTAssertEqualWithAccuracy(bar.progress, 0.3, 1e-6);
    XCTAssertEqual(bar.behavior, YLProgressBarBehaviorDefault);
    XCTAssertFalse(bar.hideGloss);
    // XCTAssertNil(bar.progressTintColors); // the default value might be trickie
    XCTAssertNotEqualObjects(bar.progressTintColor, [UIColor blackColor]);
    XCTAssertEqual(bar.progressBarInset, 1);
    XCTAssertNotNil(bar.indicatorTextLabel);
    XCTAssertNil(bar.indicatorTextLabel.text);
    XCTAssertEqual(bar.indicatorTextDisplayMode, YLProgressBarIndicatorTextDisplayModeNone);
    XCTAssertEqual(bar.type, YLProgressBarTypeRounded);
    XCTAssertTrue(bar.stripesAnimated);
    XCTAssertEqual(bar.stripesDirection, YLProgressBarStripesDirectionRight);
    XCTAssertEqualWithAccuracy(bar.stripesAnimationVelocity, 1, 1e-6);
    XCTAssertEqual(bar.stripesOrientation, YLProgressBarStripesOrientationRight);
    XCTAssertEqual(bar.stripesWidth, 7);
    XCTAssertEqualObjects(bar.stripesColor, [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.28f]);
    XCTAssertEqual(bar.stripesDelta, 8);
    XCTAssertFalse(bar.hideStripes);
    XCTAssertFalse(bar.hideTrack);
}

#pragma mark - FBSnapshotTestCase tests

- (void)testDefaultBar
{
    FBSnapshotVerifyView(bar, nil);
}

@end
