//
//  Settings+CoreDataClass.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 22/07/2017.
//   
//

#import "Settings+CoreDataClass.h"
#import "GridManager.h"

@implementation Settings

// There can be only only instances of settings
+(Settings *)getSettings:(NSManagedObjectContext *) context{
    Settings *settings;
    NSManagedObjectModel *model = [[context persistentStoreCoordinator] managedObjectModel];
    NSFetchRequest* request = [model fetchRequestTemplateForName: @"SettingsFetchRequest"];
    
    // Check if query retrived from model
    if(request){
        NSError* error = nil;
        NSArray* results = [context  executeFetchRequest:request error:&error];
        
        if(error){
            // Fetch Request query failed
            [[NSNotificationCenter defaultCenter] postNotificationName: kApplicationRaisedAnException object:self userInfo: @{@"NSERROR" : error}];
        }else{
            settings = [results firstObject];
            if(!settings){
                settings =[NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:context];
                // Save the context.
                NSError *saveContextError = nil;
                if (![context save:&saveContextError])
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName: kApplicationRaisedAnException object:self userInfo: @{@"NSERROR" : saveContextError}];
                }
            }
        }
    }
    return settings;
}
@end
