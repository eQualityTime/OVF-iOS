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
#import "SoundOptionCell.h"
#import "Constants.h"
#import "UITableViewCell+Category.h"
#import "GridManager+Speech.h"

@interface SettingsViewController ()
@property (nonatomic) NSArray<NSString *> *sectionList;
@property (nonatomic) NSArray<NSString *> *settingsList;
@property (nonatomic) NSArray<NSString *> *resourceList;
@property (nonatomic) NSArray<NSString *> *soundList;
@property (nonatomic) NSDictionary<NSString *,NSString *> *voiceLanguageOptions;
@end

@implementation SettingsViewController

typedef NS_ENUM(NSUInteger, SettingsSectionType) {
    kSettingsSection,
    kResourceSection,
    kSoundSection
};

typedef NS_ENUM(NSUInteger, SettingsRowType) {
    kGoogleRow,
    kYoutubeRow,
    kTwitterRow
};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    [self prepareTableView];
    [self prepareSoundOptions];
}

- (void)prepareUI {
    self.title = NSLocalizedString(@"Settings", @"");
}

- (void)prepareTableView {
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.sectionList = @[
                         NSLocalizedString(@"Display Settings", @""),
                         NSLocalizedString(@"Resource URL", @""),
                         NSLocalizedString(@"Sound Setting", @"")
                         ];

    self.settingsList = @[
                          NSLocalizedString(@"Google", @""),
                          NSLocalizedString(@"Youtube", @""),
                          NSLocalizedString(@"Twitter", @"")
                          ];
    self.resourceList = @[NSLocalizedString(@"", @"")];
    self.soundList = @[NSLocalizedString(@"", @"")];
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
            SoundOptionCell *cell = (SoundOptionCell *)[tableView dequeueReusableCellWithIdentifier:[SoundOptionCell reuseIdentifier] forIndexPath:indexPath];
            NSString *currentVoiceLanguage = [GridManager sharedInstance].voiceLanguage;
            NSString *speakerName = self.voiceLanguageOptions[currentVoiceLanguage];
            [cell setupCellWithSpeakerName:speakerName];
            return cell;
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
    }
}

@end
