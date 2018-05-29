//
//  OBZDownloadManager.h
//  CommuniKate
//
//  Created by Ahmet Yalcinkaya on 30.04.2018.
//  Copyright © 2018 Flickaway Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZipArchive/ZipArchive.h>
#import "OBZManifest.h"
#import "Board.h"

@interface OBZDownloadManager : NSObject <SSZipArchiveDelegate>

- (NSDictionary *)convertOBZDataDictionary:(NSData *)data;
- (OBZManifest *)getManifestFromPath:(NSString *)path;
- (Board *)getBoardFromPath:(NSString *)path;
- (NSString *)getOBZFilePath;
- (NSString *)getDownloadedOBZPath;

@end
