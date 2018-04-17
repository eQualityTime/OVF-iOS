//
//  ScanningCoordinator.m
//  CommuniKate
//
//  Created by Ahmet Yalcinkaya on 7.04.2018.
//  Copyright © 2018 Flickaway Limited. All rights reserved.
//

#import "ScanningCoordinator.h"
#import "Constants.h"

@implementation ScanningCoordinator

- (instancetype)init {
    if (self = [super init]) {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (ScanningMode)mode {
    BOOL rowColumnScanningOn = [self.userDefaults boolForKey:kRowColumnScanningIsOnKey];
    if (!rowColumnScanningOn) {
        return kScanningModeLinear;
    } else {
        return kScanningModeRowColumn;
    }
}

- (void)startScanning {
    self.isScanning = YES;

    double scanTime = [self.userDefaults doubleForKey:kScanTimeKey];
    if (scanTime == 0.0) {
        scanTime = kDefaultScanningTime;
    }

    [self performSelector:@selector(updateScanning) withObject:nil afterDelay:0.05];
    self.scanningTimer = [NSTimer scheduledTimerWithTimeInterval:scanTime
                                                          target:self
                                                        selector:@selector(updateScanning)
                                                        userInfo:nil
                                                         repeats:YES];
}

- (void)stopScanning {
    self.isScanning = NO;
    [self.scanningTimer invalidate];
    self.scanningTimer = nil;
    self.previousScanningIndex = 0;
    self.currentScanningIndex = 0;
    self.currentScanningRowIndex= 0;
    self.previousScanningRowIndex = 0;

    self.rowColumnScanningMode = kRowColumnScanningModeRow;
    [self.scanningController clearPreviousScanningView];
    [self.scanningController clearPreviousScanningViewForColumn];
}

- (void)updateScanning {
    if (!self.isScanning) { return; }
    
    switch (self.mode) {
        case kScanningModeLinear:
            [self updateLinearScanning];
            break;
        case kScanningModeRowColumn:
            [self updateRowColumnScanning];
            break;
    }
}

- (void)updateLinearScanning {
    // deactivate previous scanning view
    [self.scanningController clearPreviousScanningView];
    
    [self.scanningController updateLinearScanning];
    
    self.previousScanningIndex = self.currentScanningIndex;
    self.currentScanningIndex++;
}

- (void)updateRowColumnScanning {
    switch (self.rowColumnScanningMode) {
        case kRowColumnScanningModeRow:
            [self updateRowColumnScanningModeRow];
            break;
        case kRowColumnScanningModeColumn:
            [self updateRowColumnScanningModeColumn];
            break;
    }
}

- (void)updateRowColumnScanningModeRow {
    // deactivate previous scanning row
    [self.scanningController clearPreviousScanningRow];
    
    [self.scanningController updateRowColumnScanning];
    
    self.currentScanningIndex = 0;
    self.previousScanningRowIndex = self.currentScanningRowIndex;
    self.currentScanningRowIndex++;
    if (self.currentScanningRowIndex >= 5) {
        self.currentScanningRowIndex = 0;
    }
}

- (void)updateRowColumnScanningModeColumn {
    // deactivate previous scanning view
    [self.scanningController clearPreviousScanningViewForColumn];

    [self.scanningController updateRowColumnScanningModeColumn];
    
    self.previousScanningIndex = self.currentScanningIndex;
    self.currentScanningIndex++;
}

@end
