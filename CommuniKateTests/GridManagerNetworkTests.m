//
//  GridManagerNetworkTests.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 24/07/2017.
//   
//

#import <XCTest/XCTest.h>
#import "CommuniKateTests.h"
#import "GridManager+Network.h"
#import "GridManager+Store.h"
#import "OBZDownloadManager.h"

@interface GridManagerNetworkTests : XCTestCase
@end

@implementation GridManagerNetworkTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testHostAvailable{
    NSURL *url = [NSURL URLWithString:testPath];
    BOOL HostAvailable = [GridManager isHostAvailable: url];
    XCTAssertTrue(HostAvailable, @"Host server is not avaliable to make requests");
}

- (void)testGetRequest{
    runTestInMainLoop(^(BOOL *done) {
        NSURL *url = [NSURL URLWithString: testPath];
        
        [GridManager get:url completion:^(NSData* _Nonnull data) {
            XCTAssertNotNil(data, @"Resource %@ not avaiable", url);
            XCTAssertTrue([data isKindOfClass:[NSData class]], @"Received data in wrong format");
            *done = YES;
        } error:^(NSError * _Nonnull error) {
            // NSLog(@"error message: \nError caused by: \n%@ User info: \n%@",  [error description], [error userInfo]);
            XCTAssertNil(error, @"");
            *done = YES;
        }];
    });
}

- (void)testGetJSON{
    runTestInMainLoop(^(BOOL *done) {
        NSURL *url = [NSURL URLWithString: testPath];
        
        [GridManager getJSON: url completion:^(NSDictionary * _Nonnull data) {
            if([data objectForKey: kGridKey]){
                XCTAssertNotNil(data, @"JSON Download failed");
                XCTAssertTrue([data isKindOfClass:[NSDictionary class]], @"Expected data to be NSDictionary, but reveiced type %@", [data class]);
                *done = YES;
            }
        } error:^(NSError * _Nonnull error) {
            // NSLog(@"error message: \nError caused by: \n%@ User info: \n%@",  [error description], [error userInfo]);
            XCTAssertNil(error, @"");
            *done = YES;
        }];
    });
}

- (void)testGetObz {
    runTestInMainLoop(^(BOOL *done) {
        NSURL *url = [NSURL URLWithString:testObzPath];
        
        [GridManager getOBZ:url completion:^(NSData *data) {
            XCTAssertNotNil(data, @"Obz download failed");
            if (data) {
                NSDictionary *grids = [[OBZDownloadManager new] convertOBZDataDictionary:data];
                XCTAssertNotNil(grids, @"Obz file is successfully converted into grids");
                *done = YES;
            }
        } error:^(NSError *error) {
            XCTAssertNil(error, @"");
            *done = YES;
        }];
    });
}

- (void)testPerformanceGetRequest {
    // performance network latancy.
    [self measureBlock:^{
        runTestInMainLoop(^(BOOL *done) {
            NSURL *url = [NSURL URLWithString: testPath];
            [GridManager get:url completion:^(NSData* _Nonnull data) {
                *done = YES;
            } error:^(NSError * _Nonnull error) {
                *done = YES;
            }];
        });
    }];
}

@end
