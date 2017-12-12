//
//  GridManager+Store.h
//  CommuniKate
//
//  Created by Kalpesh Modha on 13/07/2017.
//   
//

#import "GridManager.h"

@interface GridManager (Store)
+(NSDictionary *_Nullable)parseRemoteData: (NSDictionary *_Nonnull) data;
+(NSDictionary *_Nullable)parse:(NSArray *_Nonnull) grid;
+(NSURL *_Nullable)applicationDocumentsDirectory;
+(NSURL *_Nullable)jsonDirectory;
+(NSURL *_Nullable)JSONDownloadURL;
+(void)readJSON: (NSString *_Nonnull) filename completion:(void (^_Nullable)(NSDictionary * _Nonnull data)) completionHandler error: (void (^_Nonnull)(NSError * _Nonnull error)) errorHandler;
+(void)saveJSON: (NSDictionary *_Nonnull) data completion:(void (^_Nullable)(BOOL success)) completionHandler error: (void (^_Nullable)(NSError * _Nullable error)) errorHandler;


+(BOOL) removeFolder:(NSURL *  _Nonnull) url;
+(void)writeJSONToLocalStorage:(NSString *_Nonnull)filename jsonDictionary: (NSDictionary *_Nonnull) infoDictionary completion:(void (^_Nullable)(BOOL success)) completionHandler error: (void (^_Nonnull)(NSError * _Nonnull error)) errorHandler;
+(NSString *_Nullable)dictionaryToJSONPrettyPrinted:(NSDictionary *_Nonnull) dictionary;
@end

