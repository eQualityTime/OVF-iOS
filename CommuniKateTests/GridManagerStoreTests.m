//
//  GridManagerStoreTests.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 24/07/2017.
//   
//

#import <XCTest/XCTest.h>
#import "CommuniKateTests.h"
#import "GridManager+Network.h"
#import "GridManager+Store.h"
#import "GridManager+Settings.h"

@interface GridManagerStoreTests : XCTestCase
@property (strong, nonatomic, nonnull) GridManager *manager;
@end

@implementation GridManagerStoreTests

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

-(void)testJSONDirectory{
    NSURL *JSONDirectory = [GridManager jsonDirectory];
    XCTAssertNotNil(JSONDirectory, @"Failed to retrive local folder for json download file:\n%@", JSONDirectory);
}



-(void)testPersistentContainer{
    XCTAssertNotNil([_manager persistentContainer], @"Failed to instantiate Persistent Container");
}

-(void)testFetchDataFromServer{
    runTestInMainLoop(^(BOOL *done) {
        NSURL *url = [NSURL URLWithString: testPath];
        
        [GridManager getJSON: url completion:^(NSDictionary * _Nonnull dictionary) {
            XCTAssertNotNil(dictionary, @"Resource %@ not avaiable", kPageSetJSON);
            XCTAssertTrue([dictionary isKindOfClass:[NSDictionary class]], @"Expected data to be NSDictionary, but reveiced type %@", [dictionary class]);
           
            BOOL isValidData = [GridManager validateData: dictionary];
            XCTAssertTrue(isValidData, @"Dictionary failed validation, did not contain expected keys (Settings and/or Grid).");
            *done = YES;
        } error:^(NSError * _Nonnull error) {
            // NSLog(@"error message: \nError caused by: \n%@ User info: \n%@",  [error description], [error userInfo]);
            XCTAssertNil(error, @"");
            *done = YES;
        }];
    });
}

-(void)testParseRemoteGridData{
    runTestInMainLoop(^(BOOL *done) {
        NSURL *url =  [NSURL URLWithString: testPath];
        [GridManager getJSON: url completion:^(NSDictionary * _Nonnull dictionary) {
            NSDictionary *parsedDictionary = [GridManager parseRemoteData: dictionary];
            XCTAssertNotNil(parsedDictionary, @"Dictionary failed to parsed");
            *done = YES;
        } error:^(NSError * _Nonnull error) {
            // NSLog(@"error message: \nError caused by: \n%@ User info: \n%@",  [error description], [error userInfo]);
            XCTAssertNil(error, @"");
            *done = YES;
        }];
    });
}

-(void)testJSONFromParsedDictionary{
    runTestInMainLoop(^(BOOL *done) {
        NSURL *url =  [NSURL URLWithString: testPath];
        [GridManager getJSON: url completion:^(NSDictionary * _Nonnull dictionary) {
            NSDictionary *parsedDictionary = [GridManager parseRemoteData: dictionary];
            NSString *json = [GridManager dictionaryToJSONPrettyPrinted:parsedDictionary];
            XCTAssertNotNil(json, @"Failed to parse dictionary to json");
            *done = YES;
        } error:^(NSError * _Nonnull error) {
            // NSLog(@"error message: \nError caused by: \n%@ User info: \n%@",  [error description], [error userInfo]);
            XCTAssertNil(error, @"");
            *done = YES;
        }];
    });
}



- (void)testSaveJSON{
    runTestInMainLoop(^(BOOL *done) {
        
        NSURL *url = [NSURL URLWithString: testPath];
        
        [GridManager getJSON:url completion:^(NSDictionary * _Nonnull data) {
            [GridManager saveJSON:data completion:^(BOOL success) {
                XCTAssertTrue(success, @"Failed to write json to local storage");
                *done = YES;
            } error:^(NSError * _Nullable error) {
                // NSLog(@"error message: \nError caused by: \n%@ User info: \n%@",  [error description], [error userInfo]);
                XCTAssertNil(error, @"");
                *done = YES;
            }];
        } error:^(NSError * _Nonnull error) {
            // NSLog(@"error message: \nError caused by: \n%@ User info: \n%@",  [error description], [error userInfo]);
            XCTAssertNil(error, @"");
            *done = YES;
        }];
    });
}

// If this test fails, try running testSaveJSON first. JSON file may not be saved.
- (void)testReadJSON{
    runTestInMainLoop(^(BOOL *done) {
        [GridManager readJSON: kPageSetJSON completion:^(NSDictionary * _Nonnull data) {
            XCTAssertNotNil(data, @"Resource %@ not avaiable", kPageSetJSON);
            XCTAssertTrue([data isKindOfClass:[NSDictionary class]], @"Expected data to be NSDictionary, but reveiced type %@", [data class]);
            BOOL isValidData = [GridManager validateData: data];
            XCTAssertTrue(isValidData, @"Data failed validation, did not contain expected keys (Settings and/or Grid).");
            *done = YES;
        } error:^(NSError * _Nonnull error) {
            // NSLog(@"error message: \nError caused by: \n%@ User info: \n%@", [error description], [error userInfo]);
            XCTAssertNil(error, @"");
            *done = YES;
        }];
    });
}

@end

