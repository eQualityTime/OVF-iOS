//
//  SwitchCell.m
//  CommuniKate
//
//  Created by Ahmet Yalcinkaya on 23.12.2017.
//  Copyright © 2017 Flickaway Limited. All rights reserved.
//

#import "SwitchCell.h"

@interface SwitchCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchView;
@property (nonatomic,strong) SwitchValueChanged switchValueChangedBlock;
@end

@implementation SwitchCell

- (void)setupCellWithTitle:(NSString *)title isSwitchOn:(BOOL)isSwitchOn valueChangedBlock:(SwitchValueChanged)valueChangedBlock {
    self.titleLabel.text = title;
    self.switchView.on = isSwitchOn;
    self.switchValueChangedBlock = valueChangedBlock;
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    self.switchValueChangedBlock(self.switchView.isOn);
}

@end
