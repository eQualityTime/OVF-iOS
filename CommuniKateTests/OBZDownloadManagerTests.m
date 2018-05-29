//
//  OBZDownloadManagerTests.m
//  CommuniKateTests
//
//  Created by Ahmet Yalcinkaya on 29.05.2018.
//  Copyright © 2018 Flickaway Limited. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OBZDownloadManager.h"
#import "OBZManifest.h"
#import "Board.h"

@interface OBZDownloadManagerTests : XCTestCase
@property (strong, nonatomic, nonnull) OBZDownloadManager *manager;
@end

@implementation OBZDownloadManagerTests

- (void)setUp {
    [super setUp];
    
    _manager = [[OBZDownloadManager alloc] init];
}

- (void)tearDown {
    [super tearDown];
    
    _manager = nil;
}

- (void)testOBZIsDownloaded {
    NSString *downloadedOBZFilePath = [self.manager getDownloadedOBZPath];
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:downloadedOBZFilePath];
    XCTAssertTrue(fileExist, @"Obz file is saved locally");
}

- (void)testOBZFilePath {
    NSString *obzFilePath = [self.manager getOBZFilePath];
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:obzFilePath];
    XCTAssertTrue(fileExist, @"Obz file is unzipped locally");
}

- (void)testManifestFile {
    OBZManifest *manifest = [self getManifest];
    XCTAssertNotNil(manifest.root, @"Manifest has no root");
    XCTAssertNotNil(manifest.boards, @"Manifest has no boards");
    XCTAssertNotNil(manifest.images, @"Manifest has no images");
}

- (void)testRootPath {
    NSString *rootPath = [self rootPath];
    BOOL isRootFileExist = [[NSFileManager defaultManager] fileExistsAtPath:rootPath];
    XCTAssertTrue(isRootFileExist, @"Root file is not exist");
}

- (void)testRootBoard {
    NSString *rootPath = [self rootPath];

    Board *board = [self.manager getBoardFromPath:rootPath];
    XCTAssertNotNil(board.boardId, @"Board has no id");
    XCTAssertNotNil(board.name, @"Board must have a name");
    XCTAssertFalse([board.name isEqualToString:@""], @"Board name can not be empty");

    XCTAssertNotNil(board.grid, @"Board has no grid");
    XCTAssertTrue(board.grid.rowCount > 0, @"Board must have more than 0 rows");
    XCTAssertTrue(board.grid.columnCount > 0, @"Board must have more than 0 columns");
    XCTAssertTrue(board.grid.rowCount == board.grid.order.count, @"Grid row count must be equal to order array count");
}

#pragma mark: - Test Helper Funcs

- (OBZManifest *)getManifest {
    NSString *manifestPath = [NSString stringWithFormat:@"%@/manifest.json", [self.manager getOBZFilePath]];
    OBZManifest *manifest = [self.manager getManifestFromPath:manifestPath];
    return manifest;
}

- (NSString *)rootPath {
    OBZManifest *manifest = [self getManifest];
    NSString *rootPath = [NSString stringWithFormat:@"%@/%@", [self.manager getOBZFilePath], manifest.root];
    return rootPath;
}

@end
