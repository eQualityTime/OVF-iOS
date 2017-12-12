//
//  GridViewControllerTests.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 23/07/2017.
//
//

#import <XCTest/XCTest.h>
#import "CommuniKateTests.h"
#import "GridManager.h"
#import "GridViewController.h"

@interface GridViewControllerTests : XCTestCase
@property(strong, nonatomic) GridViewController *controller;
@end

@implementation GridViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.controller = [[GridViewController alloc] init];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.controller = nil;
    [super tearDown];
}

- (void)testExample {
    [self.controller clearGridView];
}

-(void)testBackspace{
    NSString *testString = @"aeiou";
    self.controller.dialogue.text = testString;
    [self.controller backspace: nil];
    XCTAssert(testString.length == self.controller.dialogue.text.length + 1, @"Dialogue text failed to be reduced by one character (Backspace)");
}

-(void)testBlank{
    // No action yet
}

-(void)testClear{
    self.controller.dialogue.text = @"aeiou";
    [self.controller clear: nil];
    XCTAssert([self.controller.dialogue.text isEqualToString:@""], @"Dialogue text failed  to be cleared");
}

-(void)testDeleteWord{
    self.controller.dialogue.text = @"This is a test to delete last word";
    NSArray *initalTextTokens = [[NSArray alloc] initWithArray: [self.controller.dialogue.text componentsSeparatedByString:@" "]];
    [self.controller deleteword: nil];
    NSArray *finalTextTokens = [[NSArray alloc] initWithArray: [self.controller.dialogue.text componentsSeparatedByString:@" "]];
    XCTAssert(initalTextTokens.count == finalTextTokens.count + 1 , @"Grid Controller failed to remove last word from dialogue text");
}

-(void)testOpen{
    // Alternative method to change grid, not used in this application
}

-(void)testPlace{
    // Test for My Day gird where sub grids spelling and number behave like a keyboard input, items are appended to dialogue test
    NSArray *item  = @[@"ovf", @"place", @"e", @"r" ];
    self.controller.dialogue.text = @"football";
    [self.controller place: item];
    
    XCTAssert([self.controller.dialogue.text isEqualToString:@"footballer"] , @"Grid Controller failed to place input from My Grid into dialogue text");

}

- (void)testPerformanceChangeGrid {
    [self measureBlock:^{
        Grid *grid = [Grid getGridByName: @"home" inManagedObjectContext:  [[GridManager sharedInstance] managedObjectContext]];
        [self.controller changeToGrid:grid];
    }];
}

@end
