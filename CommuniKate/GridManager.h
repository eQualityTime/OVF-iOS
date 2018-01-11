//
//  GridManager.h
//  CommuniKate
//
//  Created by Kalpesh Modha on 13/07/2017.
//   
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Cell+CoreDataClass.h"
#import "Grid+CoreDataClass.h"
#import "Image+CoreDataClass.h"
#import "Link+CoreDataClass.h"
#import "Settings+CoreDataClass.h"

#import "CellView.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#ifndef GRID_MANAGER
#define GRID_MANAGER

// Application Error
extern NSString *_Nonnull const kApplicationRaisedAnException;
// Network Notifications
extern NSString *_Nonnull const kHostNotAvailableNotification;
extern NSString *_Nonnull const kDownloadCompletedNotification;
extern NSString *_Nonnull const kDownloadErrorNotification;
extern NSString *_Nonnull const kDownloadSaveErrorNotification;
extern NSString *_Nonnull const kDownloadFailedErrorNotification ;
extern NSString *_Nonnull const kDownloadUnexpectedFormatErrorNotification;
extern NSString *_Nonnull const kFileNotFoundNotification;
extern NSString *_Nonnull const kFileAlreadyExistsNotification;
extern NSString *_Nonnull const kDidTapViewNotification;
extern NSString *_Nonnull const kGridsNeedDownloadingNotification;
extern NSString *_Nonnull const kGridsLoadedNotification;

// Resource URLs
extern NSString *_Nonnull const kPageSetJSON;
// Dictionary Keys
extern NSString *_Nonnull const kGridKey;
// Folder
extern NSString *_Nonnull const  kJSONFolder;
//Grid
extern NSString *_Nonnull const kDefaultGrid;
// Site Links
extern NSString *_Nonnull const  kTwitter;
extern NSString *_Nonnull const kGoogle;
extern NSString *_Nonnull const kYouTube;
//Speech
extern NSString *_Nonnull const kSpeakTextNotification;

@interface GridManager : NSObject

@property (strong, nonatomic) AVSpeechSynthesizer *_Nullable synthesizer;

// Core Data
@property (readonly, strong) NSPersistentContainer * _Nullable persistentContainer;
@property (strong, nonatomic) Settings *_Nullable settings;

+ (instancetype _Nonnull)sharedInstance;
+(NSString *_Nullable)arrayToColorString:(NSArray *_Nonnull) array;
+(UIColor *_Nullable)colorFromString:(NSString *_Nonnull)colorString;
+(void) getImageForCell:(Cell *_Nonnull) cell inView:(CellView *_Nonnull) view rect:(CGRect) rect;

+(void)setDomain:(NSURL *_Nonnull) domain;
+(void)clearDomain;
+(NSURL *_Nullable)getJSONURL;
+(NSURL *_Nullable)getDomain;

-(NSManagedObjectContext *_Nullable)managedObjectContext;
-(void)saveContext;
-(void)buildDataFromURL:(NSURL *_Nonnull) url completion:(void (^_Nonnull)(BOOL success)) completionHandler error: (void (^_Nonnull)(NSError * _Nonnull error)) errorHandler;
-(BOOL)clearData;
-(BOOL)removeStore;

@end

#endif
