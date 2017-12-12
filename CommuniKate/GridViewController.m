//
//  ViewController.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 13/07/2017.
//   
//

#import "GridViewController.h"
#import "GridManager+Store.h"
#import "GridManager+Network.h"
#import "GridManager+Speech.h"
#import "GridManager+Settings.h"
#import "UIView+Layer.h"
#import "GridView.h"
#import "CellView.h"

#import "UIView+Animation.h"
#import "WebViewController.h"

#import "DownloadViewController.h"
#import "AppDelegate.h"

@interface GridViewController () <DownloadViewControllerDelegate>
@property (strong, nonatomic) GridManager *gridManager;
@property (strong, nonatomic) Grid *visiableGrid;
@property (strong, nonatomic) UITextView *dialogue;
@property (weak, nonatomic) IBOutlet GridView *gridView;
@end

@implementation GridViewController

-(GridManager *)gridManager{
    if(!_gridManager){
        _gridManager = [GridManager sharedInstance];
    }
    return _gridManager;
}

-(UITextView *)dialogue{
    if(!_dialogue){
        _dialogue = [[UITextView alloc] init];
        _dialogue.backgroundColor = [UIColor colorWithRed:0.99f green:0.99f  blue:0.99f  alpha:1.0f];
        
        [_dialogue.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.25] CGColor]];
        [_dialogue.layer setBorderWidth:1.0];
        _dialogue.layer.cornerRadius = 0;
        _dialogue.clipsToBounds = YES;
        _dialogue.userInteractionEnabled = YES;
        _dialogue.scrollEnabled = YES;
        
        [_dialogue setFont:[UIFont systemFontOfSize: 26.0f]];
    }
    return _dialogue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // Instantiate dialogue text view that will be shared when the grid changes
    self.gridView.dialogue =  self.gridView.dialogue ?  self.gridView.dialogue: self.dialogue;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gridsNeedsSetup:) name: kGridsNeedDownloadingNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellTouched:) name: kDidTapViewNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(speak:) name: kSpeakTextNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unexpectedFormat:) name: kDownloadUnexpectedFormatErrorNotification object: nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString *path = [[GridManager getJSONURL] absoluteString];
    BOOL urlContainsJSONExtension = [path containsString:@".json"];
    if(urlContainsJSONExtension){
        [self loadDefaultGrid:nil];
    }else{
        [self performSegueWithIdentifier:@"Download Segue" sender:self];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.gridView setNeedsDisplayInRect: self.view.bounds];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segue
//-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
//    BOOL shouldPerformSegue = true;
//    if([identifier isEqualToString:@"Download Segue"]){
//        shouldPerformSegue = [GridManager isHostAvailable];
//        if(!shouldPerformSegue){
//            [self internetConnectionRequired];
//        }
//    }
//    return shouldPerformSegue;
//}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"Download Segue"]){
        DownloadViewController *controller = (DownloadViewController *)segue.destinationViewController;
        [controller setDelegate: self];
    }else{
        NSString *navigationControllerTitle;
        NSString *resource;
        
        if([segue.identifier isEqualToString: @"YouTubeSegue"]){
            navigationControllerTitle = @"You Tube";
            resource = [NSString stringWithFormat:kYouTube, self.dialogue.text];
        }else if([segue.identifier isEqualToString: @"TwitterSegue"]){
            navigationControllerTitle = @"Twitter";
            resource = [NSString stringWithFormat:kTwitter, self.dialogue.text];
        } else{
            navigationControllerTitle = @"Google";
            resource = [NSString stringWithFormat:kGoogle, self.dialogue.text];
        }
        
        NSString* encodedUrl = [resource stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURLRequest *requestURL = [NSURLRequest requestWithURL: [NSURL URLWithString: encodedUrl]];
        
        UINavigationController *navController = [segue destinationViewController];
        
        WebViewController *controller = [[navController viewControllers] firstObject];
        controller.request = requestURL;
        controller.title =  NSLocalizedString(navigationControllerTitle, nil);
    }
}

#pragma mark - speech
- (IBAction)speak:(id)sender {
    [self.gridManager speak:  self.dialogue.text];
}

#pragma mark - Notifications

-(void)cellTouched:(NSNotification *) notification{
    CellView *cellView = notification.userInfo[@"cell"];
    Cell *cell = cellView.cell;
    // NSLog(@"%@",[cell description]);
    [self animateInView: cellView];
    
    if(cell.isLink){
        [self processOvfLink: cell];
    }else{
        NSString *text = [NSString stringWithFormat:@"%@ %@", self.dialogue.text , cell.text];
        self.dialogue.text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}

-(void)unexpectedFormat:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName: kApplicationRaisedAnException object:self userInfo: userInfo];
}

-(void)animateInView:(UIView *) view{
    if(view){
        view.alpha = 0.7f;
        [view setHidden:NO];
        [UIView animateWithDuration:0.25f animations:^{
            view.alpha = 1.0f;
        }];
        [view setNeedsDisplayInRect: view.bounds];
    }
}

-(void)changeToGrid:(Grid *) grid{
    [self clearGridView];
    self.gridView.grid = grid;
    [self animateInView: self.gridView];
    [self.gridView setNeedsDisplay];
}

// Clear up previous grid (release memory and remove notification observers)
-(void)clearGridView{
    NSArray *cellViewsToRemove = [self.gridView subviews];
    for (CellView *cellView in cellViewsToRemove) {
        [[NSNotificationCenter defaultCenter] removeObserver:cellView];
        [cellView removeFromSuperview];
    }
}

-(void)loadDefaultGrid:(NSNotification *) notification{
    
    NSManagedObjectContext *context = self.gridManager.managedObjectContext;
    if(context){
        NSUInteger count = [Grid gridsCount: context];
        if(count){
            Grid *grid = [Grid getGridByName: kDefaultGrid inManagedObjectContext: context];
            if(grid){
                [self changeToGrid: grid];
            }
        }
    }
}

-(void)gridsNeedsSetup:(NSNotification *) notification{
    NSURL *downloadURL = notification.userInfo[@"url"];
    if([GridManager isHostAvailable:downloadURL]){
        [self.gridManager buildDataFromURL:downloadURL completion:^(BOOL success){
            if(success){
                NSManagedObjectContext *managedObjectContext = [self.gridManager managedObjectContext];
                [managedObjectContext performBlock:^{
                    NSError *error;
                    [managedObjectContext save:&error];
                    if(!error){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self viewWillDisappear: true];
                            [self viewDidLoad];
                            [self viewWillAppear: true];
                            [self viewDidAppear: true];
                        });
                    }
                }];
            }else{
                // file format not recognised
                NSDictionary *errorDetails = @{
                                               @"error": NSLocalizedString(@"Download Format", nil),
                                               @"message": NSLocalizedString(@"Download format not recognised, please check your source", nil),
                                               };
                
                [[NSNotificationCenter defaultCenter] postNotificationName: kDownloadUnexpectedFormatErrorNotification object:self userInfo: errorDetails];
            }
        } error:^(NSError * _Nonnull error) {
            [[NSNotificationCenter defaultCenter] postNotificationName: kApplicationRaisedAnException object:self userInfo: @{@"NSERROR" : error}];
        }];
    }else{
        [self internetConnectionRequired];
    }
}

#pragma mark - Process commands
-(NSString *)sanitizeString:(NSString *) string{
    NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSString *sanitizeString = [string stringByRemovingPercentEncoding];
    sanitizeString= [[sanitizeString  componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@" "];
    sanitizeString= [sanitizeString  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    sanitizeString= [sanitizeString  stringByRemovingPercentEncoding];
    
    return  sanitizeString;
}

-(void)processOvfLink:(Cell *) cell{
    if(cell.link){
        if([cell.link.linkRef containsString:@"ovf"]){
            [self processLinkCommad:cell];
        }else{
            
            if(!cell.link.grid){
                // Attempt to set inverse relationship lazily
                Grid *grid = [Grid getGridByName:cell.link.linkRef inManagedObjectContext:self.gridManager.managedObjectContext];
                
                if(grid){
                    cell.link.grid = grid;
                    NSError *error;
                    [cell.managedObjectContext save: &error];
                    if(error){
                        // Failed to save core data context
                        [[NSNotificationCenter defaultCenter] postNotificationName: kApplicationRaisedAnException object:self userInfo: @{@"NSERROR" : error}];
                        
                        // NSLog(@"error message: \nError caused by: \n%@ User info: \n%@",  [error description], [error userInfo]);
                        // abort();
                    }
                }
            }
            [self changeToGrid: cell.link.grid];
        }
    }
}

-(void)processLinkCommad:(Cell *) cell{
    NSArray *commands = [cell.link.linkRef componentsSeparatedByString:@","];
    for (NSString *command in commands) {
        
        NSArray *tokens = [[self sanitizeString: command] componentsSeparatedByString:@" "];
        
        if([[tokens firstObject] isEqualToString:@"ovf"]){
            if(tokens.count > 1){
                NSString *command = [NSString stringWithFormat: @"%@:", tokens[1]];
                @try {
                    SEL aSelector = NSSelectorFromString(command);
                    [self performSelector: aSelector withObject:tokens];
                } @catch (NSException *exception) {
                    // For now do nothhing,
                    // NSLog(@"command : %@ not supported", command);
                }
            }
        }
    }
}

-(void)backspace:(NSArray *)tokens{
    self.dialogue.text = [self.dialogue.text substringToIndex:[self.dialogue.text length]-1];
}

-(void)blank:(NSArray *)tokens{
    // Do Nothing
}

-(void)clear:(NSArray *)tokens{
    self.dialogue.text = @"";
}

-(void)deleteword:(NSArray *)tokens{
    NSMutableArray *textTokens = [[NSMutableArray alloc] initWithArray: [self.dialogue.text componentsSeparatedByString:@" "]];
    [textTokens removeLastObject];
    NSString *text =@"";
    for (NSString *string in textTokens) {
        text =  [NSString stringWithFormat:@"%@ %@", text , string];
    }
    self.dialogue.text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

-(void)open:(NSArray *)tokens{
    if(tokens.count >= 3){
        Grid *grid = [Grid getGridByName: tokens[2] inManagedObjectContext:self.gridManager.managedObjectContext];
        [self changeToGrid:(Grid *) grid];
    }
}

-(void)place:(NSArray *)tokens{
    if(tokens.count >= 3){
        NSString *text = self.dialogue.text;
        for(int i=2; i<tokens.count;i++){
            text = [NSString stringWithFormat:@"%@%@", text, tokens[i]];
        }
        self.dialogue.text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}

-(void)unfinnished:(NSArray *)tokens{
    NSString *title = NSLocalizedString(@"Feature", nil);
    
    NSString *message = [NSString stringWithFormat:@"At present this feature is not available."];
    
    NSString *cancelButtonTitle = NSLocalizedString(@"Close", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                   {
                                       // Do Nothing
                                   }];
    //Add the actions.
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)settings:(id)sender {
    
    NSString *title = NSLocalizedString(@"Download", nil);
    NSString *message =  NSLocalizedString(@"Download application resourses from internet.", nil);
    
    NSString *cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
    NSString *downloadButtonTitle = NSLocalizedString(@"Download", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                   {
                                       // Do Nothing
                                   }];
    
    UIAlertAction *downloadAction = [UIAlertAction actionWithTitle:downloadButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                                     {
                                         [[NSNotificationCenter defaultCenter] postNotificationName: kGridsNeedDownloadingNotification object:self userInfo: nil];
                                     }];
    //Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:downloadAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)internetConnectionRequired{
    NSString *title = NSLocalizedString(@"Internet Connection", nil);
    NSString *message = NSLocalizedString(@"An internet connection is required to download resources. Please connect your device to a Wi-Fi network and try again.", nil);
    NSString *buttonTitle = NSLocalizedString(@"Close", nil);
    
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [delegate showAlert:title message:message buttonText: buttonTitle];
}


#pragma mark - DownloadViewControllerDelegate
-(void) downloadViewController:(DownloadViewController *) controller downloadFromURL:(NSURL *)url{
    [[NSNotificationCenter defaultCenter] postNotificationName: kGridsNeedDownloadingNotification object:self userInfo: @{@"url": url}];
}
@end

