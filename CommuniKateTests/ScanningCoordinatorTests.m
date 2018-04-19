//
//  ScanningCoordinatorTests.m
//  CommuniKateTests
//
//  Created by Ahmet Yalcinkaya on 8.04.2018.
//  Copyright © 2018 Flickaway Limited. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ScanningCoordinator.h"
#import "Constants.h"

@interface ScanningCoordinatorTests : XCTestCase
@property(strong, nonatomic) ScanningCoordinator *coordinator;
@property(strong, nonatomic) NSUserDefaults *defaults;
@end

@implementation ScanningCoordinatorTests

- (void)setUp {
    [super setUp];
    self.coordinator = [ScanningCoordinator new];

    NSString *suiteName = @"TestDefaultsForScanning";
    [[NSUserDefaults new] removeSuiteNamed:suiteName];
    self.coordinator.userDefaults = [[NSUserDefaults alloc] initWithSuiteName:suiteName];
}

- (void)testIsScanning {
    XCTAssertFalse(self.coordinator.isScanning);

    [self.coordinator startScanning];
    
    XCTAssertTrue(self.coordinator.isScanning);
    
    [self.coordinator stopScanning];
    
    XCTAssertFalse(self.coordinator.isScanning);
}

- (void)testScanningIndexForLinearScanning {
    [self.coordinator.userDefaults setBool:NO forKey:kRowColumnScanningIsOnKey];
    [self.coordinator.userDefaults setDouble:0.2 forKey:kScanTimeKey];

    XCTAssert(self.coordinator.currentScanningIndex == 0);
    
    [self.coordinator startScanning];
    
    [self wait:0.1];
    
    XCTAssert(self.coordinator.previousScanningIndex == 0);
    XCTAssert(self.coordinator.currentScanningIndex == 1);
    
    [self wait:0.2];
    
    XCTAssert(self.coordinator.previousScanningIndex == 1);
    XCTAssert(self.coordinator.currentScanningIndex == 2);
}

- (void)testScanningIndexForRowColumnScanning {
    [self.coordinator.userDefaults setBool:YES forKey:kRowColumnScanningIsOnKey];
    [self.coordinator.userDefaults setDouble:0.2 forKey:kScanTimeKey];
    
    XCTAssert(self.coordinator.currentScanningIndex == 0);
    XCTAssert(self.coordinator.currentScanningRowIndex == 0);

    [self.coordinator startScanning];
    
    [self wait:0.15];
    
    XCTAssert(self.coordinator.currentScanningIndex == 0);
    XCTAssert(self.coordinator.currentScanningRowIndex == 1);
    
    [self wait:0.15];
    
    XCTAssert(self.coordinator.currentScanningIndex == 0);
    XCTAssert(self.coordinator.currentScanningRowIndex == 2);
    
    self.coordinator.rowColumnScanningMode = kRowColumnScanningModeColumn;
    [self wait:0.15];

    XCTAssert(self.coordinator.previousScanningIndex == 0);
    XCTAssert(self.coordinator.currentScanningIndex == 1);
    XCTAssert(self.coordinator.currentScanningRowIndex == 2);
    
    [self wait:0.3];

    XCTAssert(self.coordinator.previousScanningIndex == 1);
    XCTAssert(self.coordinator.currentScanningIndex == 2);
    XCTAssert(self.coordinator.currentScanningRowIndex == 2);
}

#pragma mark - Helper Functions

- (void)wait:(NSTimeInterval)interval {
    XCTestExpectation *expectation = [self expectationWithDescription:@"wait"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:interval handler:nil];
}

@end
