//
//  UIView+Category.m
//  CommuniKate
//
//  Created by Ahmet Yalcinkaya on 14.04.2018.
//  Copyright © 2018 Flickaway Limited. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

- (void)addScanningBorder {
    self.layer.borderColor = [UIColor colorWithRed:255/255.0 green:190/255.0 blue:0.0 alpha:1.0].CGColor;
    self.layer.borderWidth = 3.0;
}

- (void)removeScanningBorder {
    if ([self isKindOfClass:[UITextView class]]) {
        // set border for dialogue
        [self.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.25] CGColor]];
        self.layer.borderWidth = 1.0;
    } else {
        self.layer.borderWidth = 0.0;
    }
}

@end
