//
//  GridManagerSpeechTests.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 24/07/2017.
//   
//

#import <XCTest/XCTest.h>
#import "CommuniKateTests.h"
#import "GridManager+Speech.h"

@interface GridManagerSpeechTests : XCTestCase
@property (strong, nonatomic, nonnull) GridManager *manager;
@end

@implementation GridManagerSpeechTests

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

- (void)testSpeechSynthesizerInstantiation {
    AVSpeechSynthesizer *synthesizer = [self.manager synthesizer];
    XCTAssertNotNil(synthesizer, @"Speech Synthesizer instantiation failed");
    
    GridManager *manager = [GridManager sharedInstance];
    [manager speak:@"Speech Synthesizer is working"];  // Don't expect to hear anything while testing 

}



@end
