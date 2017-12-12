//
//  Cell+CoreDataProperties.h
//  CommuniKate
//
//  Created by Kalpesh Modha on 19/08/2017.
 

#import "Cell+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Cell (CoreDataProperties)

+ (NSFetchRequest<Cell *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *color;
@property (nonatomic) BOOL hasImage;
@property (nonatomic) BOOL isLink;
@property (nullable, nonatomic, copy) NSString *text;
@property (nullable, nonatomic, copy) NSDecimalNumber *x;
@property (nullable, nonatomic, copy) NSDecimalNumber *y;
@property (nullable, nonatomic, retain) Grid *grid;
@property (nullable, nonatomic, retain) Image *image;
@property (nullable, nonatomic, retain) Link *link;

@end

NS_ASSUME_NONNULL_END
