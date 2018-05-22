//
//  Board.h
//  CommuniKate
//
//  Created by Ahmet Yalcinkaya on 30.04.2018.
//  Copyright © 2018 Flickaway Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BoardButton;
@class BoardButtonLoadBoard;
@class BoardImage;
@class BoardGrid;

@interface Board : NSObject

@property (nonatomic) NSString *boardId;
@property (nonatomic) NSString *name;
@property (nonatomic) BoardGrid *grid;
@property (nonatomic) NSArray<BoardButton *> *buttons;
@property (nonatomic) NSArray<BoardImage *> *images;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface BoardButton : NSObject

@property (nonatomic) NSInteger buttonId;
@property (nonatomic) NSString *label;
@property (nonatomic) NSString *backgroundColor;
@property (nonatomic) NSString *imageId;
@property (nonatomic) BoardButtonLoadBoard *loadBoard;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface BoardButtonLoadBoard : NSObject

@property (nonatomic) NSString *path;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface BoardImage : NSObject

@property (nonatomic) NSString *imageId;
@property (nonatomic) NSString *path;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface BoardGrid : NSObject

@property (nonatomic) NSInteger rowCount;
@property (nonatomic) NSInteger columnCount;
@property (nonatomic) NSArray<NSArray *> *order;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
