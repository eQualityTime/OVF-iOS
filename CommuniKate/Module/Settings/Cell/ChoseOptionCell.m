//
//  ChooseOptionCell.m
//  CommuniKate
//
//  Created by Ahmet Yalcinkaya on 10.01.2018.
//  Copyright © 2018 Flickaway Limited. All rights reserved.
//

#import "ChoseOptionCell.h"

@interface ChooseOptionCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation ChooseOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setupCellWithTitle:(NSString *)title value:(NSString *)value {
    self.titleLabel.text = title;
    self.nameLabel.text = value;
}

@end
