//
//  Image+CoreDataProperties.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 19/08/2017.
 

#import "Image+CoreDataProperties.h"

@implementation Image (CoreDataProperties)

+ (NSFetchRequest<Image *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Image"];
}

@dynamic data;
@dynamic name;
@dynamic uri;
@dynamic cell;

@end
