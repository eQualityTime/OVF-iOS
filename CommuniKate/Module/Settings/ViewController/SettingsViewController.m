//
//  SettingsViewController.m
//  CommuniKate
//
//  Created by Ahmet Yalcinkaya on 23.12.2017.
//  Copyright © 2017 Flickaway Limited. All rights reserved.
//

#import "SettingsViewController.h"
#import "SwitchCell.h"
#import "DownloadCell.h"
#import "ChoseOptionCell.h"
#import "Constants.h"
#import "UITableViewCell+Category.h"
#import "GridManager+Speech.h"

@interface SettingsViewController ()
@property (nonatomic) NSArray<NSString *> *sectionList;
@property (nonatomic) NSArray<NSString *> *settingsList;
@property (nonatomic) NSArray<NSString *> *resourceList;
@property (nonatomic) NSArray<NSString *> *soundList;
@property (nonatomic) NSArray<NSString *> *scanningList;
@property (nonatomic) NSDictionary<NSString *,NSString *> *voiceLanguageOptions;
@property (nonatomic) NSArray<NSString *> *scanningOptions;
@end

@implementation SettingsViewController

typedef NS_ENUM(NSUInteger, SettingsSectionType) {
    kSettingsSection,
    kResourceSection,
    kSoundSection,
    kScanningSection
};

typedef NS_ENUM(NSUInteger, SettingsRowType) {
    kGoogleRow,
    kYoutubeRow,
    kTwitterRow
};

typedef NS_ENUM(NSUInteger, ScanningRowType) {
    kScanningSwitchRow,
    kScanningTimeRow
};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    [self prepareTableView];
    [self prepareSoundOptions];
    [self prepareScanningOptions];
}

- (void)prepareUI {
    self.title = NSLocalizedString(@"Settings", @"");
}

- (void)prepareTableView {
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.sectionList = @[
                         NSLocalizedString(@"Display Settings", @""),
                         NSLocalizedString(@"Resource URL", @""),
                         NSLocalizedString(@"Sound Setting", @""),
                         NSLocalizedString(@"Scanning Setting", @"")
                         ];

    self.settingsList = @[
                          NSLocalizedString(@"Google", @""),
                          NSLocalizedString(@"Youtube", @""),
                          NSLocalizedString(@"Twitter", @"")
                          ];
    
    self.resourceList = @[NSLocalizedString(@"", @"")];
    self.soundList = @[NSLocalizedString(@"Speaker Name", @"")];
    self.scanningList = @[NSLocalizedString(@"Scanning", @""),
                          NSLocalizedString(@"Scanning Time", @"")
                          ];

}

- (void)prepareSoundOptions {
    self.voiceLanguageOptions = @{
                                  @"en-GB" : @"Daniel",
                                  @"en-US" : @"Samantha",
                                  @"en-AU" : @"Karen",
                                  @"en-IE" : @"Moira",
                                  @"en-ZA" : @"Tessa"
                                  };
}

- (void)prepareScanningOptions {
    self.scanningOptions = @[
                             @"1",
                             @"2",
                             @"3",
                             @"5",
                             @"10"
                             ];
}

#pragma mark - Actions

- (IBAction)closeButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Sound Options

- (void)openSoundOptionsSheet {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Choose Speaker", nil) message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSString *language in self.voiceLanguageOptions.allKeys) {
        
        NSString *speakerName = self.voiceLanguageOptions[language];

        NSString *title = [NSString stringWithFormat:@"%@ - %@", speakerName, language];
        
        UIAlertAction *speakerAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self changeSpeakerLanguage:language];
            NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndex:kSoundSection];
            [self.tableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        
        [actionSheet addAction:speakerAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:cancelAction];

    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)changeSpeakerLanguage:(NSString *)language {
    [[GridManager sharedInstance] changeVoiceLanguage:language];
}

#pragma mark - Scanning Options

- (void)openScanningOptionsSheet {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Choose Scanning Time", nil) message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSString *scanTimeTitle in self.scanningOptions) {
        
        UIAlertAction *scanningAction = [UIAlertAction actionWithTitle:scanTimeTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self changeScanningTime:scanTimeTitle];
            NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndex:kScanningSection];
            [self.tableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        
        [actionSheet addAction:scanningAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)changeScanningTime:(NSString *)scanTime {
    double scanTimeDouble = scanTime.doubleValue;
    [[NSUserDefaults standardUserDefaults] setDouble:scanTimeDouble forKey:kScanTimeKey];
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case kSettingsSection:
            return self.settingsList.count;
        case kResourceSection:
            return self.resourceList.count;
        case kSoundSection:
            return self.soundList.count;
        case kScanningSection:
            return self.scanningList.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case kSettingsSection: {
            SwitchCell *cell = (SwitchCell *)[tableView dequeueReusableCellWithIdentifier:[SwitchCell reuseIdentifier] forIndexPath:indexPath];
            BOOL isSwitchOn = YES;
            NSString *switchKey = @"";
            
            switch (indexPath.row) {
                case kGoogleRow:
                    switchKey = kGoogleDisplayKey;
                    break;
                case kYoutubeRow:
                    switchKey = kYoutubeDisplayKey;
                    break;
                case kTwitterRow:
                    switchKey = kTwitterDisplayKey;
                    break;
                default:
                    break;
            }
            
            isSwitchOn = [[NSUserDefaults standardUserDefaults] boolForKey:switchKey];
            
            [cell setupCellWithTitle:self.settingsList[indexPath.row] isSwitchOn:isSwitchOn valueChangedBlock:^(BOOL isSwitchOn) {
                [[NSUserDefaults standardUserDefaults] setBool:isSwitchOn forKey:switchKey];
            }];
            
            return cell;

        }
        case kResourceSection: {
            DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:[DownloadCell reuseIdentifier] forIndexPath:indexPath];
            
            __weak typeof(self) weakSelf = self;
            [cell setupCellWithDownloadRequestedBlock:^{
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }];
            return cell;
        }
        case kSoundSection: {
            ChooseOptionCell *cell = (ChooseOptionCell *)[tableView dequeueReusableCellWithIdentifier:[ChooseOptionCell reuseIdentifier] forIndexPath:indexPath];
            NSString *currentVoiceLanguage = [GridManager sharedInstance].voiceLanguage;
            NSString *speakerName = self.voiceLanguageOptions[currentVoiceLanguage];
            NSString *title = self.soundList[indexPath.row];
            [cell setupCellWithTitle:title value:speakerName];
            return cell;
        }
        case kScanningSection: {
            if (indexPath.row == kScanningSwitchRow) {
                SwitchCell *cell = (SwitchCell *)[tableView dequeueReusableCellWithIdentifier:[SwitchCell reuseIdentifier] forIndexPath:indexPath];
                
                NSString *switchKey = kScanningStatusKey;
                BOOL isSwitchOn = [[NSUserDefaults standardUserDefaults] boolForKey:switchKey];
                
                [cell setupCellWithTitle:self.scanningList[indexPath.row] isSwitchOn:isSwitchOn valueChangedBlock:^(BOOL isSwitchOn) {
                    [[NSUserDefaults standardUserDefaults] setBool:isSwitchOn forKey:switchKey];
                }];
                
                return cell;
            } else {
                ChooseOptionCell *cell = (ChooseOptionCell *)[tableView dequeueReusableCellWithIdentifier:[ChooseOptionCell reuseIdentifier] forIndexPath:indexPath];
                
                double scanTime = [[NSUserDefaults standardUserDefaults] doubleForKey:kScanTimeKey];
                if (scanTime == 0.0) {
                    scanTime = kDefaultScanningTime;
                }
                NSString *scanningValue = [NSString stringWithFormat:@"%.1lf", scanTime];
                NSString *title = self.scanningList[indexPath.row];
                [cell setupCellWithTitle:title value:scanningValue];
                return cell;
            }
        }
        default:
            return [UITableViewCell new];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionList[section];
}

#pragma mark - TableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == kSoundSection) {
        [self openSoundOptionsSheet];
    } else if (indexPath.section == kScanningSection && indexPath.row == kScanningTimeRow) {
        [self openScanningOptionsSheet];
    }
}

@end
