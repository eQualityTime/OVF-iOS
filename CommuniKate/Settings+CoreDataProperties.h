//
//  Settings+CoreDataProperties.h
//  CommuniKate
//
//  Created by Kalpesh Modha on 19/08/2017.
 

#import "Settings+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Settings (CoreDataProperties)

+ (NSFetchRequest<Settings *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *adminemail;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSDecimalNumber *gridSize;
@property (nullable, nonatomic, copy) NSString *language;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *version;
@end

NS_ASSUME_NONNULL_END
