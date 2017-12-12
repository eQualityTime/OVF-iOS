//
//  Cell+CoreDataProperties.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 19/08/2017.
 

#import "Cell+CoreDataProperties.h"

@implementation Cell (CoreDataProperties)

+ (NSFetchRequest<Cell *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Cell"];
}

@dynamic color;
@dynamic hasImage;
@dynamic isLink;
@dynamic text;
@dynamic x;
@dynamic y;
@dynamic grid;
@dynamic image;
@dynamic link;

@end
