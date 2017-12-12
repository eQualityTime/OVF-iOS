//
//  Link+CoreDataProperties.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 19/08/2017.
 

#import "Link+CoreDataProperties.h"

@implementation Link (CoreDataProperties)

+ (NSFetchRequest<Link *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Link"];
}

@dynamic linkRef;
@dynamic cell;
@dynamic grid;

@end
