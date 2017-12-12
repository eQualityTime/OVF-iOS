//
//  Image+CoreDataProperties.h
//  CommuniKate
//
//  Created by Kalpesh Modha on 19/08/2017.
 

#import "Image+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Image (CoreDataProperties)

+ (NSFetchRequest<Image *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSData *data;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *uri;
@property (nullable, nonatomic, retain) Cell *cell;

@end

NS_ASSUME_NONNULL_END
