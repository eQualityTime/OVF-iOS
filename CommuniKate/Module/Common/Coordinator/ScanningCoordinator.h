//
//  ScanningCoordinator.h
//  CommuniKate
//
//  Created by Ahmet Yalcinkaya on 7.04.2018.
//  Copyright © 2018 Flickaway Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LinearScanningProtocol
- (void)updateLinearScanning;
- (void)updateRowColumnScanning;
- (void)clearPreviousScanningView;
@end

@protocol RowColumnScanningProtocol
- (void)updateRowColumnScanningModeColumn;
- (void)clearPreviousScanningRow;
- (void)clearPreviousScanningViewForColumn;
@end

typedef NS_ENUM(NSUInteger, ScanningMode) {
    kScanningModeLinear,
    kScanningModeRowColumn
};

typedef NS_ENUM(NSUInteger, RowColumnScanningMode) {
    kRowColumnScanningModeRow,
    kRowColumnScanningModeColumn
};

@interface ScanningCoordinator : NSObject

@property (nonatomic) BOOL isScanning;
@property (nonatomic) NSInteger currentScanningIndex;
@property (nonatomic) NSInteger currentScanningRowIndex;
@property (nonatomic) NSInteger previousScanningIndex;
@property (nonatomic) NSInteger previousScanningRowIndex;
@property (nonatomic) NSTimer *scanningTimer;
@property (nonatomic) ScanningMode mode;
@property (nonatomic) RowColumnScanningMode rowColumnScanningMode;
@property (nonatomic) NSUserDefaults *userDefaults;

@property (weak) id <LinearScanningProtocol, RowColumnScanningProtocol> scanningController;

- (void)startScanning;
- (void)stopScanning;

@end
