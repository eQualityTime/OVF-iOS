//
//  GridManagerSettingsTests.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 20/08/2017.
 

#import <XCTest/XCTest.h>
#import "GridManager+Settings.h"

@interface GridManagerSettingsTests : XCTestCase

@end

@implementation GridManagerSettingsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGridManagerSharedInstance {
    GridManager *manager = [GridManager sharedInstance];
    XCTAssertNotNil(manager, @"Grid Manager failed to provide a shared instance");
}

- (void)testFetchSettings {
    GridManager *manager = [GridManager sharedInstance];
    Settings *settings = [manager getSettings];
    XCTAssertNotNil(settings, @"Failed to instantiate Settings");
}

@end
