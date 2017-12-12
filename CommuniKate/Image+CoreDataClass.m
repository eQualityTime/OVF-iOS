//
//  Image+CoreDataClass.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 15/07/2017.
//   
//

#import "Image+CoreDataClass.h"
#import "Cell+CoreDataClass.h"
#import "GridManager+Network.h"
#import "GridManager+Store.h"


@implementation Image

// Data from local storage converted to UIImage
+(UIImage *)getImage:(NSData *) data{
    return [UIImage imageWithData: data];
}

@end
