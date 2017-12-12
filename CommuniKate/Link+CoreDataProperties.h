//
//  Link+CoreDataProperties.h
//  CommuniKate
//
//  Created by Kalpesh Modha on 19/08/2017.
 

#import "Link+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Link (CoreDataProperties)

+ (NSFetchRequest<Link *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *linkRef;
@property (nullable, nonatomic, retain) Cell *cell;
@property (nullable, nonatomic, retain) Grid *grid;

@end

NS_ASSUME_NONNULL_END
