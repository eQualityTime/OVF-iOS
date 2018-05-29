//
//  OBZDownloadManager.m
//  CommuniKate
//
//  Created by Ahmet Yalcinkaya on 30.04.2018.
//  Copyright © 2018 Flickaway Limited. All rights reserved.
//

#import "OBZDownloadManager.h"
#import "GridManager.h"

@implementation OBZDownloadManager

- (NSDictionary *)convertOBZDataDictionary:(NSData *)data {
    NSString *path = [self getDownloadedOBZPath];

    BOOL fileCreated = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    if (!fileCreated && !fileExist) { return nil; }

    NSString *unzipPath = [self getOBZFilePath];
    if (!unzipPath) { return nil; }
    
    BOOL success = [SSZipArchive unzipFileAtPath:path
                                   toDestination:unzipPath
                              preserveAttributes:YES
                                       overwrite:YES
                                  nestedZipLevel:0
                                        password:nil
                                           error:nil
                                        delegate:nil
                                 progressHandler:nil
                               completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
                                   NSLog(@"%@", [error localizedDescription]);
                               }];
    
    if (!success) { return nil; }
    
    NSError *error = nil;
    NSMutableArray<NSString *> *items = [[[NSFileManager defaultManager]
                                          contentsOfDirectoryAtPath:unzipPath
                                          error:&error] mutableCopy];
    if (error) { return nil; }
    if (!items || items.count == 0) { return nil; }
    
    NSString *manifestPath = [NSString stringWithFormat:@"%@/manifest.json", unzipPath];
    OBZManifest *manifest = [self getManifestFromPath:manifestPath];
    
    NSMutableArray<Board *> *boardList = [NSMutableArray new];
    for (NSString *obfFile in manifest.boards.allValues) {
        NSString *obfPath = [NSString stringWithFormat:@"%@/%@", unzipPath, obfFile];
        Board *board = [self getBoardFromPath:obfPath];
        if (board) {
            [boardList addObject:board];
        }
    }
    
    NSDictionary *gridDictionary = [self convertBoardsToCells:boardList];
    return gridDictionary;
}

- (NSDictionary *)convertBoardsToCells:(NSArray *)boardList {
    NSMutableDictionary *parsedGrid = [NSMutableDictionary new];
    
    for (Board *board in boardList) {
        NSMutableDictionary *parsedBoard = [NSMutableDictionary new];
        [parsedBoard addEntriesFromDictionary:@{
                                               @"gridID": board.boardId,
                                               @"name": board.name
                                               }];
        
        NSMutableArray *cells = [NSMutableArray new];
        
        for (int y = 0; y < board.grid.rowCount; y++) {
            NSArray *row = board.grid.order[y];
            for (int x = 0; x < board.grid.columnCount; x++) {
                id column = row[x];
                if ([column isKindOfClass:[NSNull class]]) {
                    continue;
                }
                NSInteger buttonId = [column integerValue];
                
                BoardButton *button = [self findButtonWithId:buttonId board:board];
                if (!button) { continue; }
                CGPoint point = CGPointMake(x, y);
                NSDictionary *cell = [self convertButtonToCell:button inBoardList:boardList toPoint:point];
                if (cell) {
                    [cells addObject:cell];
                }
            }
            
        }
        [parsedBoard setObject:cells forKey: @"cells"];
        [parsedGrid setObject:parsedBoard forKey:board.name];
    }
    
    return [parsedGrid copy];
}

- (NSDictionary *)convertButtonToCell:(BoardButton *)button inBoardList:(NSArray *)boardList toPoint:(CGPoint)point{
    NSString *link = button.loadBoard ? [self getNameOfTheBoardWithId:button.loadBoard.path boardList:boardList] : @"";
    NSString *image = @"";
    if (button.imageId) {
        image = [NSString stringWithFormat:@"%@/\%@",
                 NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0],
                 button.imageId];
    }
    
    NSArray *colorArray = [GridManager colorStringToArray:button.backgroundColor];
    @try {
        NSDictionary *cell = @{
                               @"color": [GridManager arrayToColorString:colorArray],
                               @"link": link,
                               @"image": image,
                               @"text": button.label,
                               @"x":  [NSNumber numberWithInt:point.x],
                               @"y":  [NSNumber numberWithInt:point.y],
                               };
        return cell;
    } @catch (NSException *exception) {
        NSLog(@"Error Message\nError caused by: \n%@ User info: \n%@",  [exception description], [exception userInfo]);
        abort();
    }
    
    return nil;
}

#pragma mark - Private

- (BoardButton *)findButtonWithId:(NSInteger)buttonId board:(Board *)board {
    for (BoardButton *button in board.buttons) {
        if (button.buttonId == buttonId) {
            return button;
        }
    }
    return nil;
}

- (NSString *)getNameOfTheBoardWithId:(NSString *)boardPath boardList:(NSArray *)boardList {
    for (Board *board in boardList) {
        if ([boardPath containsString:board.boardId]) {
            return board.name;
        }
    }
    return @"";
}

- (OBZManifest *)getManifestFromPath:(NSString *)path {
    NSDictionary *dictionary = [self getDictionaryFromPath:path];
    if (dictionary) {
        return [[OBZManifest alloc] initWithDictionary:dictionary];
    }
    return nil;
}

- (Board *)getBoardFromPath:(NSString *)path {
    NSDictionary *dictionary = [self getDictionaryFromPath:path];
    if (dictionary) {
        return [[Board alloc] initWithDictionary:dictionary];
    }
    return nil;
}

- (NSDictionary *)getDictionaryFromPath:(NSString *)path {
    BOOL isFileExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!isFileExist) { return nil; }
    
    NSData *obfData = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:obfData options:kNilOptions error:nil];
}

- (NSString *)getOBZFilePath {
    NSString *path = [NSString stringWithFormat:@"%@/\%@",
                      NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0],
                      @"obzPath"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtURL:url
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:&error];
    if (error) {
        return nil;
    }
    return url.path;
}

- (NSString *)getDownloadedOBZPath {
    return [NSString stringWithFormat:@"%@/\%@",
            NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0],
            @"downloaded.obz"];
}

@end
