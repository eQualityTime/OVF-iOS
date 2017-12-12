//
//  Settings+CoreDataProperties.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 19/08/2017.
 

#import "Settings+CoreDataProperties.h"

@implementation Settings (CoreDataProperties)

+ (NSFetchRequest<Settings *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Settings"];
}

@dynamic adminemail;
@dynamic date;
@dynamic gridSize;
@dynamic language;
@dynamic title;
@dynamic version;
@end
