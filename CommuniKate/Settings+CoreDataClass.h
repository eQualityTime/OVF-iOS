//
//  Settings+CoreDataClass.h
//  CommuniKate
//
//  Created by Kalpesh Modha on 22/07/2017.
//   
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Settings : NSManagedObject
+(Settings * _Nullable)getSettings:(NSManagedObjectContext *) context;
@end

NS_ASSUME_NONNULL_END

#import "Settings+CoreDataProperties.h"
