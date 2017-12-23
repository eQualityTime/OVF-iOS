//
//  SettingsViewController.m
//  CommuniKate
//
//  Created by Ahmet Yalcinkaya on 23.12.2017.
//  Copyright © 2017 Flickaway Limited. All rights reserved.
//

#import "SettingsViewController.h"
#import "SwitchCell.h"
#import "Constants.h"

@interface SettingsViewController ()
@property (nonatomic) NSArray *sectionList;
@property (nonatomic) NSArray *settingsList;
@property (nonatomic) NSArray *resourceList;
@end

@implementation SettingsViewController

typedef NS_ENUM(NSUInteger, SettingsSectionType) {
    kSettingsSection,
    kResourceSection
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
}

- (void)prepareUI {
    self.title = NSLocalizedString(@"Settings", @"");
}

- (void)prepareTableView {
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.sectionList = @[NSLocalizedString(@"Display Settings", @""), NSLocalizedString(@"Resource URL", @"")];
    self.settingsList = @[NSLocalizedString(@"Google", @""), NSLocalizedString(@"Youtube", @""), NSLocalizedString(@"Twitter", @"")];
    self.resourceList = @[NSLocalizedString(@"", @"")];
}

#pragma mark - Actions

- (IBAction)closeButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == kSettingsSection) {
        return self.settingsList.count;
    } else {
        return self.resourceList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == kSettingsSection) {
        SwitchCell *cell = (SwitchCell *)[tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
        BOOL isSwitchOn = NO;
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
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadCell" forIndexPath:indexPath];
        
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionList[section];
}

@end
