//
//  Image+CoreDataClass.h
//  CommuniKate
//
//  Created by Kalpesh Modha on 15/07/2017.
//   
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Cell;

NS_ASSUME_NONNULL_BEGIN

@interface Image : NSManagedObject
+(UIImage *)getImage:(NSData *) data;
@end

NS_ASSUME_NONNULL_END

#import "Image+CoreDataProperties.h"
