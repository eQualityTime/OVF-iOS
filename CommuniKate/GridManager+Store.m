//
//  GridManager+Store.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 13/07/2017.
//   
//

#import "GridManager+Store.h"
#import "GridManager+Settings.h"

@implementation GridManager (Store)

// Convert segmented JSON data into a structured dictionary
+(NSDictionary *)parseRemoteData: (NSDictionary *_Nonnull) data{
    NSMutableDictionary *structuredGrids;
    if([data objectForKey: kGridKey]){
        structuredGrids = [[NSMutableDictionary alloc] init];
        // Only intrested in Grid key, Settings key is ignored
        NSDictionary *gridData = [[data objectForKey:@"Grid"] copy];
        NSArray *allKeys = [gridData allKeys];
        
        for (id object in allKeys) {
            NSArray *grid = [gridData valueForKey: object];
            NSDictionary *parsedGrid = [GridManager parse: grid];
            if(parsedGrid){
                structuredGrids[parsedGrid[@"name"]] = parsedGrid;
            }
        }
    }
    return [structuredGrids copy];
}

// Set each grid cell property from multiple arrays
+(NSDictionary *)parse:(NSArray *) grid{
    
    // The collection of 7 arrays for each cell expected in following format
    // [0] grid name string
    // [1] cell text array
    // [2] reserved array // ignored always empty
    // [3] links array
    // [4] images array
    // [5] color array
    // [6] grid_id number
    
    NSMutableDictionary *parsedGrid;
    
    if(grid.count == 7){
        parsedGrid = [[NSMutableDictionary alloc] init];
        [parsedGrid addEntriesFromDictionary:@{@"gridID": grid[6], @"name": grid[0]}];
        
        NSArray *gridCellsText = grid[1];
        // NSArray *cellsReserved = grid[2]; // ignored always empty
        NSArray *gridCellLinks = grid[3];
        NSArray *gridCellImagess = grid[4];
        NSArray *gridCellBackgroundColor = grid[5];
        
        NSMutableArray *cells = [[NSMutableArray alloc] init];
        
        for(int x = 0; x < gridCellsText.count; x++){
            NSArray *cellsText = gridCellsText[x];
            NSArray *cellLink = gridCellLinks[x];
            NSArray *cellImage = gridCellImagess[x];
            NSArray *cellBackgroundColor = gridCellBackgroundColor[x];
            
            for(int y = 0; y < cellsText.count; y++){
                // Ignore cells underneath the textview, as they never be accessible
                if(!(y == 0 && (x > 0 && x < 4))){
                    
                    @try {
                        NSDictionary *cell = @{
                                               @"color": [GridManager arrayToColorString: cellBackgroundColor[y]],
                                               @"link": cellLink[y],
                                               @"image": cellImage[y],
                                               @"text": cellsText[y],
                                               @"x":  [NSNumber numberWithInt: x],
                                               @"y":  [NSNumber numberWithInt: y],
                                               };
                        [cells addObject: cell];
                    } @catch (NSException *exception) {
                        NSLog(@"Error Message\nError caused by: \n%@ User info: \n%@",  [exception description], [exception userInfo]);
                        abort();
                    }
                }
            }
        }
        [parsedGrid setObject: cells forKey: @"cells"];
    }
    
    return [parsedGrid copy];
}


+(NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+(NSURL *)jsonDirectory {
    NSURL *jsonDirectory = [[GridManager applicationDocumentsDirectory]  URLByAppendingPathComponent: kJSONFolder];
    BOOL isDirectory = YES;
    if(![[NSFileManager defaultManager] fileExistsAtPath: [jsonDirectory path]  isDirectory:&isDirectory]){
        NSError *error;
        if(![[NSFileManager defaultManager] createDirectoryAtPath:[jsonDirectory path] withIntermediateDirectories:YES attributes: nil  error:&error]){
            if(error){
                [[NSNotificationCenter defaultCenter] postNotificationName: kApplicationRaisedAnException object:self userInfo: @{@"NSERROR" : error}];
                // NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                // abort();
            }
        }
    }
    return jsonDirectory;
}

+(NSURL *)JSONDownloadURL{
    return [GridManager getJSONURL];
}

+(void)readJSON: (NSString*) filename completion:(void (^)(NSDictionary *data)) completionHandler error: (void (^)(NSError *error)) errorHandler{
    NSURL *localURL = [[GridManager jsonDirectory] URLByAppendingPathComponent :  filename isDirectory:NO ];
    // Check if file already exists
    if ([[NSFileManager defaultManager] fileExistsAtPath : [localURL path]]){
        NSData *data = [NSData dataWithContentsOfFile:  [localURL path] options:NSDataReadingMappedIfSafe error:nil];
        NSDictionary *jsonDictionary= (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData: data];
        completionHandler(jsonDictionary);
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName: kFileNotFoundNotification object: nil];
        completionHandler(nil);
    }
}

+(void)saveJSON: (NSDictionary *) data completion:(void (^)(BOOL success)) completionHandler error: (void (^)(NSError *error)) errorHandler{
    BOOL isDirectory = false;
    NSURL *localURL = [[GridManager jsonDirectory] URLByAppendingPathComponent :  kPageSetJSON isDirectory: isDirectory];
    NSData *jsonData = [NSKeyedArchiver archivedDataWithRootObject: data];
    NSError *wrireError;
    
    if([jsonData writeToURL:localURL options: NSDataWritingAtomic error: &wrireError]){
        if(!wrireError){
            completionHandler(true);
        }else{
            errorHandler(wrireError);
        }
    }else{
        completionHandler(false);
    }
}

+(BOOL) removeFolder:(NSURL *) url {
    BOOL folderRemoved = false;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *pathToRemove = [url path];
    BOOL isDirectory = false;
    
    BOOL pathToRemoveExist = [fileManager fileExistsAtPath: pathToRemove isDirectory: &isDirectory];
    
    if (pathToRemoveExist && isDirectory) {
        NSError *error;
        folderRemoved = [fileManager removeItemAtPath:pathToRemove error: &error];
        
        if(error){
            
        }
    }
    return folderRemoved;
}

+(void)writeJSONToLocalStorage:(NSString *)filename jsonDictionary: (NSDictionary *_Nonnull) infoDictionary completion:(void (^_Nullable)(BOOL success)) completionHandler error: (void (^_Nonnull)(NSError * _Nonnull error)) errorHandler{
    
    NSURL *localURL = [[GridManager jsonDirectory] URLByAppendingPathComponent : filename isDirectory:NO ];
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject: infoDictionary options:kNilOptions error: &error];
    if(error){
        errorHandler(error);
    }else{
        completionHandler([data writeToFile:[localURL path] atomically:YES]);
    }
}

+(NSString *)dictionaryToJSONPrettyPrinted:(NSDictionary *) dictionary{
    NSString *jsonString;
    if(dictionary){
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject: dictionary options:NSJSONWritingPrettyPrinted error:&error];
        if(!error){
            jsonString = [[NSString alloc] initWithData: jsonData encoding:NSUTF8StringEncoding];
        }
    }
    return [jsonString copy];
}


@end

