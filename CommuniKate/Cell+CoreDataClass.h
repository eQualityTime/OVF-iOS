//
//  Cell+CoreDataClass.h
//  CommuniKate
//
//  Created by Kalpesh Modha on 15/07/2017.
//   
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Grid, Image, Link;

NS_ASSUME_NONNULL_BEGIN

@interface Cell : NSManagedObject
+(BOOL)cellHasImage: (NSDictionary *)cell;
+(BOOL)cellHasLink: (NSDictionary *)cell;
@end

NS_ASSUME_NONNULL_END

#import "Cell+CoreDataProperties.h"
