//
//  Cell+CoreDataClass.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 15/07/2017.
//   
//

#import "Cell+CoreDataClass.h"
#import "Grid+CoreDataClass.h"
#import "Image+CoreDataClass.h"
#import "Link+CoreDataClass.h"
#import "GridManager+Network.h"

@implementation Cell
+(BOOL)cellHasImage: (NSDictionary *)cell{
    NSString *imageURI =  cell[@"image"];
    return [imageURI rangeOfString:@"png"].location == NSNotFound ? false : true;
}

+(BOOL)cellHasLink: (NSDictionary *)cell{
    NSString *linkURI =  cell[@"link"];
    return [linkURI isEqualToString: @""] ? false : true;
}
@end
