//
//  Board.m
//  CommuniKate
//
//  Created by Ahmet Yalcinkaya on 30.04.2018.
//  Copyright © 2018 Flickaway Limited. All rights reserved.
//

#import "Board.h"
#import "NSArray+Category.h"

@implementation Board

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.boardId = dictionary[@"id"];
        self.name = dictionary[@"name"];
        self.grid = [[BoardGrid alloc] initWithDictionary:dictionary[@"grid"]];
        self.buttons = [dictionary[@"buttons"] arrayByConvertingDictionaryRepresentationsToObjectsWithClass:[BoardButton class]];
        self.images = [dictionary[@"images"] arrayByConvertingDictionaryRepresentationsToObjectsWithClass:[BoardImage class]];
    }
    return self;
}

@end

@implementation BoardButton

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.buttonId = [dictionary[@"id"] integerValue];
        self.label = dictionary[@"label"];
        self.backgroundColor = dictionary[@"background_color"];
        self.imageId = dictionary[@"image_id"];
        
        NSDictionary *loadBoardDictionary = dictionary[@"load_board"];
        if (loadBoardDictionary) {
            self.loadBoard = [[BoardButtonLoadBoard alloc] initWithDictionary:loadBoardDictionary];
        }
    }
    return self;
}

@end

@implementation BoardButtonLoadBoard

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.path = dictionary[@"path"];
    }
    return self;
}

@end

@implementation BoardImage

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.imageId = dictionary[@"id"];
        self.path = dictionary[@"path"];
    }
    return self;
}

@end

@implementation BoardGrid

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.rowCount = [dictionary[@"rows"] integerValue];
        self.columnCount = [dictionary[@"columns"] integerValue];
        self.order = dictionary[@"order"];
    }
    return self;
}

@end
