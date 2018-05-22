//
//  NSArray+NSArray_Category.h
//  CommuniKate
//
//  Created by Ahmet Yalcinkaya on 30.04.2018.
//  Copyright © 2018 Flickaway Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Category)

- (NSArray *)arrayByConvertingDictionaryRepresentationsToObjectsWithClass:(Class)objectClass;

@end
