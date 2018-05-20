//
//  OBZManifest.m
//  CommuniKate
//
//  Created by Ahmet Yalcinkaya on 30.04.2018.
//  Copyright © 2018 Flickaway Limited. All rights reserved.
//

#import "OBZManifest.h"

@implementation OBZManifest

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.root = dictionary[@"root"];
        NSDictionary *paths = dictionary[@"paths"];
        self.boards = paths[@"boards"];
        self.images = paths[@"images"];
    }
    return self;
}

@end
