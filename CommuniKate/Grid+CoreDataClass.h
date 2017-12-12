//
//  Grid+CoreDataClass.h
//  CommuniKate
//
//  Created by Kalpesh Modha on 15/07/2017.
//   
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Cell, Link;

NS_ASSUME_NONNULL_BEGIN

@interface Grid : NSManagedObject
+(BOOL)createGrids:(NSManagedObjectContext *) context;
+(Grid *)getGridByName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *) context;
+(NSUInteger) gridsCount:(NSManagedObjectContext *) context;
+(NSArray *)sortedKeys:(NSArray *)keys;
@end

NS_ASSUME_NONNULL_END

#import "Grid+CoreDataProperties.h"
