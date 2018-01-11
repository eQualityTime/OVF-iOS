//
//  SoundOptionCell.m
//  CommuniKate
//
//  Created by Ahmet Yalcinkaya on 10.01.2018.
//  Copyright © 2018 Flickaway Limited. All rights reserved.
//

#import "SoundOptionCell.h"

@interface SoundOptionCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation SoundOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.text = NSLocalizedString(@"Speaker Name", nil);
}

- (void)setupCellWithSpeakerName:(NSString *)name {
    self.nameLabel.text = name;
}

@end
