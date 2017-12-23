//
//  SwitchCell.h
//  CommuniKate
//
//  Created by Ahmet Yalcinkaya on 23.12.2017.
//  Copyright © 2017 Flickaway Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchCell : UITableViewCell

typedef void (^SwitchValueChanged)(BOOL);

- (void)setupCellWithTitle:(NSString *)title isSwitchOn:(BOOL)isSwitchOn valueChangedBlock:(SwitchValueChanged)valueChangedBlock;
@end
