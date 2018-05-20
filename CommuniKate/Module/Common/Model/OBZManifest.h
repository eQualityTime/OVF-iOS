//
//  OBZManifest.h
//  CommuniKate
//
//  Created by Ahmet Yalcinkaya on 30.04.2018.
//  Copyright © 2018 Flickaway Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBZManifest : NSObject

@property (nonatomic) NSString *root;
@property (nonatomic) NSDictionary *boards;
@property (nonatomic) NSDictionary *images;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
