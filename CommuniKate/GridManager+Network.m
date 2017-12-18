//
//  GridManager+Network.m
//  ebook-africa
//
//  Created by Kalpesh Modha on 08/07/2016.


#import "GridManager+Network.h"
#import "GridManager+Store.h"

// For Host reachability
#import <SystemConfiguration/SystemConfiguration.h>

@implementation GridManager (Network)

+ (Boolean)isHostAvailable:(NSURL * _Nonnull)url {
    bool canReach = false;
    
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef address;

    if (url) {
        address = SCNetworkReachabilityCreateWithName(NULL,  [[url absoluteString] UTF8String]);
        Boolean success = SCNetworkReachabilityGetFlags(address, &flags);
        CFRelease(address);
        
        canReach = success && !(flags & kSCNetworkReachabilityFlagsConnectionRequired) && (flags & kSCNetworkReachabilityFlagsReachable);
    }
    return canReach;
}

+ (void)downloadURL:(NSURL *_Nonnull)url complition:(void (^_Nullable)(BOOL success))completionHandler error:(void (^_Nullable)(NSError * _Nullable error))errorHandler {
    [GridManager getJSON: url completion: ^(NSDictionary * _Nonnull data) {
        
        if (data) {
            NSDictionary *grids = [GridManager parseRemoteData: data];
            
            [GridManager saveJSON: grids completion:^(BOOL success) {
                           if(success){
                               [GridManager setDomain:url];
                               completionHandler(success);
                           }
                       } error:^(NSError *error) {
                           // Possible causes to reach here are insufficent storage space or security settings denying write permission, examine error for details
                           errorHandler(error);
                       }];
        } else {
            NSDictionary *errorDetails = @{
                                           @"error": NSLocalizedString(@"Download Error", nil),
                                           @"message": NSLocalizedString(@"Download format not recognised, please check your source", nil),
                                           };
            
            [[NSNotificationCenter defaultCenter] postNotificationName: kDownloadFailedErrorNotification object:self userInfo: errorDetails];
            completionHandler(false);
        }
        
    } error:^(NSError * _Nonnull error) {
        // Attempt to download JSON data failed
        errorHandler(error);
        // [[NSNotificationCenter defaultCenter] postNotificationName: kApplicationRaisedAnException object:self userInfo: @{@"NSERROR" : error}];
        // NSLog(@"error message: \nError caused by: \n%@ User info: \n%@",  [error description], [error userInfo]);
        // abort();
    }];
}

+ (void)get:(NSURL  *_Nonnull )url completion:(void (^)(NSData *data))completionHandler error:(void (^)(NSError *error))errorHandler {
    if ([GridManager isHostAvailable: url]) {
        NSDictionary *headers = @{ @"cache-control": @"no-cache" };
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval: 60.0];
        [request setHTTPMethod:@"GET"];
        [request setAllHTTPHeaderFields: headers];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 ) {
                    completionHandler(data);
                } else if(httpResponse.statusCode == 404) {
                    // Server failed to provide resource
                    completionHandler(nil);
                }
            } else {
                // Network failed
                errorHandler(error);
            }
        }];
        [dataTask resume];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName: kHostNotAvailableNotification object: nil];
        completionHandler(nil);
    }
}

+(void)getJSON:(NSURL  *_Nonnull ) url completion:(void (^)(NSDictionary *data)) completionHandler error: (void (^)(NSError *error)) errorHandler{
    [GridManager get:url completion:^(NSData *data) {
        NSError *error = nil;
        NSDictionary *dataDictionary= [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingMutableContainers error: &error];
        
        BOOL isDataValid = [GridManager validateData: dataDictionary];
        if (isDataValid) {
            if (!error) {
                completionHandler(dataDictionary);
            } else{
                errorHandler(error);
            }
        } else {
            completionHandler(nil);
        }
    } error:^(NSError *error) {
        errorHandler(error);
    }];
}

+ (BOOL)validateData:(NSDictionary *)data {
    BOOL validate = false;
    
    if (data[@"Settings"] && data[@"Grid"]) {
        validate = true;
    }
    return validate;
}

@end
