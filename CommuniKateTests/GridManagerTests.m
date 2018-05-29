//
//  GridManager.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 21/07/2017.
//
//

#import <XCTest/XCTest.h>
#import "CommuniKateTests.h"
#import "GridManager.h"
#import "GridManager+Network.h"
#import "GridManager+Store.h"



@interface GridManagerTests : XCTestCase
@property (strong, nonatomic, nonnull) GridManager *manager;
@end

@implementation GridManagerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _manager = [[GridManager alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _manager = nil;
    [super tearDown];
}

-(void)testClearData {
    runTestInMainLoop(^(BOOL *done) {
        NSURL *urlToClear = [GridManager jsonDirectory];
        BOOL success = [self.manager clearData];
        if(success){
            XCTAssertTrue(success, @"Failed to clear contents in directory %@", [urlToClear path]);
            *done = YES;
        }
    });
}

-(void)testBuildData {
    runTestInMainLoop(^(BOOL *done) {
        NSURL *url = [NSURL URLWithString:testPath];
        [self.manager buildDataFromURL:url completion:^(BOOL success) {
            XCTAssertTrue(success, @"Failed to rebuild application data");
            *done = YES;
        } error:^(NSError * _Nonnull error) {
            XCTAssertNotNil(error, @"An unrecoverable error occured, see detail below for an indication\n%@", [error description]);
            *done = YES;
        }];
    });
}

-(void)testBuildObzData {
    runTestInMainLoop(^(BOOL *done) {
        NSURL *url = [NSURL URLWithString:testObzPath];
        [self.manager buildDataFromURL:url completion:^(BOOL success) {
            XCTAssertTrue(success, @"Failed to rebuild application data");
            *done = YES;
        } error:^(NSError * _Nonnull error) {
            XCTAssertNotNil(error, @"An unrecoverable error occured, see detail below for an indication\n%@", [error description]);
            *done = YES;
        }];
    });
}

@end
