//
//  OBZDownloadManager.h
//  CommuniKate
//
//  Created by Ahmet Yalcinkaya on 30.04.2018.
//  Copyright © 2018 Flickaway Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZipArchive/ZipArchive.h>

@interface OBZDownloadManager : NSObject <SSZipArchiveDelegate>

- (NSDictionary *)convertOBZDataDictionary:(NSData *)data;

@end
