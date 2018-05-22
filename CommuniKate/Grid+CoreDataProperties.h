//
//  Grid+CoreDataProperties.h
//  CommuniKate
//
//  Created by Kalpesh Modha on 19/08/2017.
 

#import "Grid+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Grid (CoreDataProperties)

+ (NSFetchRequest<Grid *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *gridID;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Cell *> *cells;
@property (nullable, nonatomic, retain) Link *link;

@end

@interface Grid (CoreDataGeneratedAccessors)

- (void)addCellsObject:(Cell *)value;
- (void)removeCellsObject:(Cell *)value;
- (void)addCells:(NSSet<Cell *> *)values;
- (void)removeCells:(NSSet<Cell *> *)values;

@end

NS_ASSUME_NONNULL_END
