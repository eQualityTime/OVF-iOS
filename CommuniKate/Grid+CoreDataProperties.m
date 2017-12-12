//
//  Grid+CoreDataProperties.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 19/08/2017.
 

#import "Grid+CoreDataProperties.h"

@implementation Grid (CoreDataProperties)

+ (NSFetchRequest<Grid *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Grid"];
}

@dynamic gridID;
@dynamic name;
@dynamic cells;
@dynamic link;

@end
