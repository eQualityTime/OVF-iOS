//
//  UITableViewCell+Category.m
//  CommuniKate
//
//  Created by Ahmet Yalcinkaya on 23.12.2017.
//  Copyright © 2017 Flickaway Limited. All rights reserved.
//

#import "UITableViewCell+Category.h"

@implementation UITableViewCell (Category)

+ (NSString *)reuseIdentifier {
    return NSStringFromClass(self);
}

@end
