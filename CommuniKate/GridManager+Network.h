//
//  GridManager+Network.h
//  ebook-africa
//
//  Created by Kalpesh Modha on 08/07/2016.


#import "GridManager.h"

@interface GridManager (Network) <NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>
+ (Boolean)isHostAvailable:(NSURL * _Nonnull)url;
+ (void)downloadURL:(NSURL *_Nonnull)url complition:(void (^_Nullable)(BOOL success))completionHandler error:(void (^_Nullable)(NSError * _Nullable error))errorHandler;
+ (void)get: (NSURL * _Nonnull )url completion:(void (^_Nonnull)(NSData *_Nonnull data ))completionHandler error: (void (^ _Nonnull)(NSError *_Nonnull error))errorHandler;
+ (void)getJSON: (NSURL  * _Nonnull )url completion:(void (^_Nonnull)(NSDictionary *_Nonnull data )) completionHandler error:(void (^ _Nonnull)(NSError *_Nonnull error))errorHandler;
+ (BOOL)validateData:(NSDictionary *_Nonnull)data;
@end
