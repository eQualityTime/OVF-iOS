//
//  GridManager.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 13/07/2017.
//   
//

#import "GridManager.h"
#import "GridManager+Network.h"
#import "GridManager+Store.h"
#import "GridManager+Settings.h"

// Application Error
NSString *const kApplicationRaisedAnException =  @"kApplicationRaisedAnException";
// Notifications
NSString *const kHostNotAvailableNotification = @"kHostNotAvailableNotification";
NSString *const kDownloadCompletedNotification = @"kDownloadCompletedNotification";
NSString *const kDownloadSaveErrorNotification = @"kDownloadSaveErrorNotification";
NSString *const kDownloadFailedErrorNotification = @"kDownloadFailedErrorNotification";
NSString *const kDownloadUnexpectedFormatErrorNotification = @"kDownloadUnexpectedFormatErrorNotification";
NSString *const kFileNotFoundNotification = @"kFileNotFoundNotification";
NSString *const kFileAlreadyExistsNotification = @" kFileAlreadyExistsNotification";
NSString *const kDidTapViewNotification = @"kDidTapViewNotification";
NSString *const kGridsNeedDownloadingNotification = @"kGridsNeedDownloadingNotification";
NSString *const kGridsLoadedNotification = @"kGridsLoadedNotification";
// Resource URLs
NSString *const kPageSetJSON = @"pageset.json";
// Dictionary Keys
NSString *const kGridKey = @"Grid";
// Folder
NSString *const  kJSONFolder = @"json";
// Grid
NSString *const  kDefaultGrid=@"toppage";
// Site Links
NSString *const kTwitter = @"https://twitter.com/intent/tweet?text=%@";
NSString *const kGoogle= @"https://www.google.co.uk/search?q=%@&tbm=isch&gws_rd=ssl";
NSString *const kYouTube= @"https://www.youtube.com/results?search_query=%@&search_type=&aq=0";
//Speech
NSString *const kSpeakTextNotification = @"kSpeakTextNotification";

@interface GridManager ()

@end

@implementation GridManager

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        // Additional initialization can go here
    });
    return _sharedObject;
}

-(AVSpeechSynthesizer *) synthesizer{
    if(!_synthesizer){
        _synthesizer= [[AVSpeechSynthesizer alloc] init];
    }
    return _synthesizer;
}

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"CommuniKate"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error) {
                    [[NSNotificationCenter defaultCenter] postNotificationName: kApplicationRaisedAnException object:self userInfo: @{@"NSERROR" : error}];
                }
            }];
        }
    }
    return _persistentContainer;
}

-(NSManagedObjectContext *)managedObjectContext{
    return self.persistentContainer.viewContext;
}

#pragma mark - Core Data Saving support
- (void)saveContext {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error = nil;
    if (context && [context hasChanges] && ![context save:&error]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName: kApplicationRaisedAnException object:self userInfo: @{@"NSERROR" : error}];
        
        // NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        // abort();
    }
}

-(void)buildDataFromURL:(NSURL *_Nonnull) url completion:(void (^_Nonnull)(BOOL success)) completionHandler error: (void (^_Nonnull)(NSError * _Nonnull error)) errorHandler{
    if([self clearData]) {
        [GridManager downloadURL:url complition:^(BOOL success) {
            if(success){
                [Grid createGrids: [self managedObjectContext]];
            }
            completionHandler(success);
        } error:^(NSError * _Nullable error) {
            errorHandler(error);
        }];
    }
}

// Remove download json data from local storage and destroy core data graph
-(BOOL)clearData{
    BOOL dataCleared = false;
    NSURL *downloadFolder =[GridManager jsonDirectory];
    if([GridManager removeFolder: downloadFolder]){
        if([self removeStore]){
            NSURL *urlFolderToRemove = [GridManager jsonDirectory];
            if([GridManager removeFolder:urlFolderToRemove])
            {
                [GridManager clearDomain];
                dataCleared = true;
            }
        }
    }
    return dataCleared;
}

-(BOOL)removeStore{
    BOOL storeRemoved = false;
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [self.persistentContainer persistentStoreCoordinator];
    NSURL *storeURL = [[[persistentStoreCoordinator  persistentStores] firstObject] URL];
    // NSLog(@"Removed Store at URL: %@", storeURL);
    
    NSError *error;
    [persistentStoreCoordinator destroyPersistentStoreAtURL:storeURL withType: NSSQLiteStoreType options:nil error:&error];
    
    if(!error){
        // Clean up recreate store
        _persistentContainer = nil;
        storeRemoved = true;
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName: kApplicationRaisedAnException object:self userInfo: @{@"NSERROR" : error}];
        
        // NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        // abort();
    }
    return storeRemoved;
}


#pragma mark - Color helper
// Convert color values from array into a core image color format
// Parameter array can be and an array or emply string
+(NSString *)arrayToColorString:(NSArray *) array{
    NSString *colorString = @"1.0 1.0 1.0 1.0"; // White default
    if([array isKindOfClass:[NSArray class]] && array.count == 3){
        
        CGFloat red = [(NSNumber *)array[0] floatValue] / 255.0;
        CGFloat green = [(NSNumber *)array[1] floatValue] / 255.0;
        CGFloat blue = [(NSNumber *)array[2] floatValue] / 255.0;
        CGFloat alpha = 1.0;
        
        colorString = [NSString stringWithFormat:@"%f %f %f %f", red, green, blue, alpha];
    }
    return colorString;
}

// Usage - UIColor *c = [GridManager colorFromString: string ];
+(UIColor *)colorFromString:(NSString *)colorString {
    UIColor *colorFromString;
    
    CIColor *colorCi = [CIColor colorWithString: colorString];
    colorFromString = [[UIColor colorWithRed: colorCi.red green: colorCi.green blue: colorCi.blue alpha: colorCi.alpha] copy];
    
    return colorFromString;
}

#pragma mark - Images
+(void) getImageForCell:(Cell *) cell inView:(CellView *) view rect:(CGRect) rect{
    
    if(cell.image){
        if(!cell.image.data){
            __weak Cell *weakCell = cell;
            __weak CellView *weakView = view;
            __block CGRect blockRect = rect;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                Cell *strongCell = weakCell;
                CellView *stongView = weakView;
                
                NSURL *imageURL = [[GridManager  getDomain] URLByAppendingPathComponent:cell.image.uri];
                
                [GridManager get: imageURL completion:^(NSData * _Nullable data) {
                    if(data){
                        strongCell.image.data = data;
                        NSError *error;
                        [strongCell.managedObjectContext save: &error];
                        
                        if(!error){
                            [GridManager setCellView: stongView withImage: strongCell.image.data inRect: blockRect];
                        }
                    }
                } error:^(NSError * _Nonnull error) {
                    [[NSNotificationCenter defaultCenter] postNotificationName: kApplicationRaisedAnException object:self userInfo: @{@"NSERROR" : error}];
                }];
            });
        }else{
            [GridManager setCellView:view withImage: cell.image.data inRect: rect];
        }
    }
}

+(void)setCellView:(CellView *) view withImage:(NSData *) data inRect:(CGRect) rect{
    if(view && data){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [Image getImage: data];
            UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
            
            imageView.frame =  rect;
            
            imageView.contentMode = UIViewContentModeCenter;
            if (imageView.bounds.size.width > (image.size.width && imageView.bounds.size.height > (image.size.height))) {
                imageView.contentMode = UIViewContentModeScaleAspectFit;
            }
            [view addSubview: imageView];
        });
    }
}

#pragma mark - Domian
// Need to store
+(void)setDomain:(NSURL *_Nonnull) url{
    if(url){
        NSUserDefaults *properties = [NSUserDefaults standardUserDefaults];
        //set list
        [properties setObject: [url absoluteString]  forKey:@"remote-json-url"];
        [properties setObject:  [[url URLByDeletingLastPathComponent] absoluteString] forKey:@"application-domain"];
        [properties synchronize]; //update & save
    }
}

+(void)clearDomain{
    NSUserDefaults *properties = [NSUserDefaults standardUserDefaults];
    //set list
    [properties setObject: @"" forKey:@"remote-json-url"];
    [properties setObject:  @"" forKey:@"application-domain"];
    [properties synchronize]; //update & save
}

+(NSURL *_Nullable)getJSONURL{
    //NSURL *url = [NSURL URLWithString: [[NSUserDefaults standardUserDefaults] objectForKey: @"remote-json-url"]];
    NSURL *url = [NSURL URLWithString: @"http://equalitytime.github.io/CommuniKate/demos/CK20V2.pptx/pageset.json"];
    
    return url;
}

+(NSURL *_Nullable)getDomain{
    return [NSURL URLWithString: [[NSUserDefaults standardUserDefaults] objectForKey:@"application-domain"]];
}

@end






