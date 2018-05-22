//
//  Grid+CoreDataClass.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 15/07/2017.
//   
//

#import "Grid+CoreDataClass.h"
#import "Cell+CoreDataClass.h"
#import "Link+CoreDataClass.h"

#import "GridManager.h"
#import "GridManager+Network.h"
#import "GridManager+Store.h"
#import "GridManager+Settings.h"

@implementation Grid

+ (Grid *)getGridByName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Grid *grid;
    
    NSManagedObjectModel *model = [[context persistentStoreCoordinator] managedObjectModel];
    NSFetchRequest* request = [model fetchRequestFromTemplateWithName: @"GridFetchRequest" substitutionVariables:@{@"NAME" : name}];
    
    NSError* error = nil;
    NSArray* results = [context  executeFetchRequest:request error:&error];
    if (error) {
        // Failed to execute fetch request
        [[NSNotificationCenter defaultCenter] postNotificationName: kApplicationRaisedAnException object:self userInfo: @{@"NSERROR" : error}];
    } else {
        grid = [results firstObject];
    }
    
    return grid;
}

+ (NSUInteger)gridsCount:(NSManagedObjectContext *)context {
    NSUInteger entityCount = 0;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Grid" inManagedObjectContext: context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    [fetchRequest setIncludesSubentities:NO];
    NSError *error = nil;
    NSUInteger count = [context countForFetchRequest: fetchRequest error: &error];
    if (!error) {
        entityCount = count;
    }
    return entityCount;
}

+ (BOOL)createGrids:(NSManagedObjectContext *)context {
    __block BOOL gridsCreated = false;
    
    NSURL *localURL = [[GridManager jsonDirectory] URLByAppendingPathComponent :  kPageSetJSON isDirectory:NO ];
    // Check if file already exists
    if ([[NSFileManager defaultManager] fileExistsAtPath:[localURL path]]) {
        
        [context performBlockAndWait:^{
            NSData *data = [NSData dataWithContentsOfFile:  [localURL path] options:NSDataReadingMappedIfSafe error:nil];
            NSDictionary *jsonDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData: data];
            
            if (jsonDictionary) {
                
                NSArray *keys = [Grid sortedKeys:[jsonDictionary allKeys]];
                
                for (NSString *key in keys) {
                    
                    Grid *newGrid = [NSEntityDescription insertNewObjectForEntityForName:@"Grid" inManagedObjectContext: context];
                    
                    NSDictionary *grid = jsonDictionary[key];
                    newGrid.name = grid[@"name"];
                    newGrid.gridID = [grid[@"gridID"] description];
                    
                    for (NSDictionary* cell in grid[@"cells"]) {
                        Cell *newCell = [NSEntityDescription insertNewObjectForEntityForName:@"Cell" inManagedObjectContext: context];
                        
                        newCell.color = cell[@"color"];
                        newCell.text = cell[@"text"];
                        newCell.x =  cell[@"x"];
                        newCell.y = cell[@"y"];
                        
                        [newGrid addCellsObject: newCell];
                        
                        newCell.isLink = [Cell cellHasLink: cell];
                        if (newCell.isLink) {
                            
                            Link *link = [NSEntityDescription insertNewObjectForEntityForName:@"Link" inManagedObjectContext:  context];
                            
                            link.linkRef = cell[@"link"];
                            link.cell = newCell;
                            
                            // set inverse relationship
                            newCell.link = link;
                            
                            // link.grid relationship needs to be setup after all grids have been created
                        }
                        
                        newCell.hasImage = [Cell cellHasImage: cell];
                        if (newCell.hasImage) {
                            
                            Image *image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:  context];
                            
                            if (image) {
                                image.cell = newCell;
                                image.name = cell[@"text"];
                                image.uri = cell[@"image"];
                                
                                // set inverse relationship
                                newCell.image = image;
                            }
                        }
                    }
                }
            }
        }];
        gridsCreated = true;
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName: kFileNotFoundNotification object: nil];
    }
    
    return gridsCreated;
}

+ (NSArray *)sortedKeys:(NSArray *)keys {
    return  [[keys  sortedArrayUsingComparator:^NSComparisonResult(NSString *key1, NSString *key2) {
        return [[key1 lastPathComponent] caseInsensitiveCompare:[key2 lastPathComponent]];
    }] copy];
}

@end
