//
//  NSArray+NSArray_Category.m
//  CommuniKate
//
//  Created by Ahmet Yalcinkaya on 30.04.2018.
//  Copyright © 2018 Flickaway Limited. All rights reserved.
//

#import "NSArray+Category.h"

@implementation NSArray (Category)

- (NSArray *)arrayByConvertingDictionaryRepresentationsToObjectsWithClass:(Class)objectClass {
    NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:[self count]];
    
    [self enumerateObjectsWithOptions:kNilOptions usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSAssert([obj isKindOfClass:[NSDictionary class]], @"Expecting dictionary object");
        NSAssert([objectClass instancesRespondToSelector:@selector(initWithDictionary:)], @"Incomplete implementation");
        id object = [[objectClass alloc] initWithDictionary:obj];
        
        NSAssert(object, @"Error creating object");
        if (object) {
            [objectArray addObject:object];
        }
    }];
    
    return [NSArray arrayWithArray:objectArray];
}

@end
