//
//  CommuniKateTests.m
//  CommuniKateTests
//
//  Created by Kalpesh Modha on 13/07/2017.
//   
//

#import <XCTest/XCTest.h>
#import "CommuniKateTests.h"
#import "GridManager.h"


NSString *const testPath = @"https://equalitytime.github.io/CommuniKate/demos/CK20V2.pptx/pageset.json";

@interface CommuniKateTests : XCTestCase

@end

@implementation CommuniKateTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testGridManagerSharedInstance{
    GridManager *manager = [GridManager sharedInstance];
    XCTAssertNotNil(manager, @"Gird Manager failed to instantiate");
}

- (void)testSortedKeysOrderedAscending{
    NSArray *keys = @[@"U", @"O", @"I", @"E", @"A"];
    
    NSArray *sortedKeys = [Grid sortedKeys: keys];
    
    for (int i = 1; i < sortedKeys.count; i++){
        if ([sortedKeys[i - 1] compare:sortedKeys[i]] != NSOrderedAscending){
            XCTAssert(false, @"Array not sorted");
        }
    }
}

- (void)testColorFromString{
    NSString *validCIColorString = @"1.0 1.0 1.0 1.0";
    NSString *invalidCIColorString = @"";
    
    UIColor *validColor = [GridManager colorFromString: validCIColorString];
    XCTAssertNotNil(validColor, @"CIColor string %@ failed to create color", validCIColorString);
    XCTAssertTrue([validColor isKindOfClass:[UIColor class]], @"Expected color to be UIColor, but reveiced type %@", [validColor class]);
    
    UIColor *inValidColor = [GridManager colorFromString: invalidCIColorString];
    XCTAssert(inValidColor, @"Expected default color to be created");
    XCTAssertTrue([inValidColor isKindOfClass:[UIColor class]], @"Expected color to be UIColor, but reveiced type %@", [validColor class]);
}
@end
