//
//  GridManager+Settings.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 20/08/2017.
 

#import "GridManager+Settings.h"

@implementation GridManager (Settings)
-(Settings *)getSettings{
    return [Settings getSettings: [self managedObjectContext]];
}



@end
