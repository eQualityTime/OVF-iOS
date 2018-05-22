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
#import "UIView+Animation.h"
#import "UIView+Category.h"
#import "WebViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface GridViewController ()
@property (strong, nonatomic) GridManager *gridManager;
@property (strong, nonatomic) Grid *visiableGrid;
@property (strong, nonatomic) UITextView *dialogue;
@property (nonatomic) BOOL pendingRequest;
@property (weak, nonatomic) IBOutlet GridView *gridView;
@property (weak, nonatomic) IBOutlet UIButton *googleButton;
@property (weak, nonatomic) IBOutlet UIButton *youtubeButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIControl *scanningView;
@property (nonatomic) ScanningCoordinator *scanningCoordinator;
@property (nonatomic) UIView *scanningRow;
@end

@implementation GridViewController

- (GridManager *)gridManager {
    if (!_gridManager) {
        _gridManager = [GridManager sharedInstance];
    }
    return _gridManager;
}

- (UITextView *)dialogue {
    if (!_dialogue) {
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

- (UIView *)scanningRowForIndex:(NSInteger)rowIndex {
    UIView *row = [UIView new];
    row.frame = CGRectMake(0, rowIndex * self.gridView.cellHeight, self.gridView.frame.size.width, self.gridView.cellHeight);
    [row addScanningBorder];
    row.userInteractionEnabled = NO;
    return row;
}

- (NSArray<UIView *> *)scanningCellsForIndex:(NSInteger)rowIndex {
    return [self.gridView.scanningCells filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(CellView *object, NSDictionary *bindings) {
        if ([object isKindOfClass:[UITextView class]]) {
            return rowIndex == 0;
        }
        return object.cell.y.integerValue == rowIndex;
    }]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gridsNeedsSetup:) name:kGridsNeedDownloadingNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self hideButtonsIfNeeded];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellTouched:) name:kDidTapViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(speak:) name:kSpeakTextNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unexpectedFormat:) name:kDownloadUnexpectedFormatErrorNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.pendingRequest) { return; }
    
    NSString *path = [[GridManager getRemoteURL] absoluteString];
    BOOL urlContainsJSONExtension = [path containsString:@".json"];
    BOOL urlContainsOBZExtension = [path containsString:@".obz"];

    if (urlContainsJSONExtension || urlContainsOBZExtension) {
        [self loadDefaultGrid:nil];
    } else {
        NSURL *defaultRemoteUrl = [NSURL URLWithString:kRemoteURLString];
        [self downloadGridFromUrl:defaultRemoteUrl];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidTapViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSpeakTextNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDownloadUnexpectedFormatErrorNotification object:nil];
    
    [self stopScanning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark - UI

- (void)prepareUI {
    // Instantiate dialogue text view that will be shared when the grid changes
    self.gridView.dialogue = self.gridView.dialogue ? self.gridView.dialogue : self.dialogue;
    
    self.scanningCoordinator = [ScanningCoordinator new];
    self.scanningCoordinator.scanningController = self;
}

- (void)hideButtonsIfNeeded {
    BOOL isGoogleSwitchOn = [[NSUserDefaults standardUserDefaults] boolForKey:kGoogleDisplayKey];
    self.googleButton.hidden = !isGoogleSwitchOn;
    
    BOOL isYoutubeSwitchOn = [[NSUserDefaults standardUserDefaults] boolForKey:kYoutubeDisplayKey];
    self.youtubeButton.hidden = !isYoutubeSwitchOn;

    BOOL isTwitterSwitchOn = [[NSUserDefaults standardUserDefaults] boolForKey:kTwitterDisplayKey];
    self.twitterButton.hidden = !isTwitterSwitchOn;
}

#pragma mark - Actions

- (IBAction)settingsTapped:(UIButton *)sender {
    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
    UINavigationController *settingsNavController = [settingsStoryboard instantiateInitialViewController];
    
    [self presentViewController:settingsNavController animated:YES completion:nil];
}

- (IBAction)googleButtonTapped:(UIButton *)sender {
    NSString *urlString = [NSString stringWithFormat:kGoogle, self.dialogue.text];
    [self navigateToWebControllerWithTitle:@"Google" urlString:urlString];
}

- (IBAction)youtubeButtonTapped:(UIButton *)sender {
    NSString *urlString = [NSString stringWithFormat:kYouTube, self.dialogue.text];
    [self navigateToWebControllerWithTitle:@"YouTube" urlString:urlString];
}

- (IBAction)twitterButtonTapped:(UIButton *)sender {
    NSString *urlString = [NSString stringWithFormat:kTwitter, self.dialogue.text];
    [self navigateToWebControllerWithTitle:@"Twitter" urlString:urlString];
}

- (IBAction)scanningViewTapped:(UIButton *)sender {
    if (!self.scanningCoordinator.isScanning) { return; }

    switch (self.scanningCoordinator.mode) {
        case kScanningModeLinear:
            [self linearScanningViewTapped];
            break;
        case kScanningModeRowColumn:
            [self rowColumnScanningViewTapped];
            break;
    }
}

- (void)linearScanningViewTapped {
    NSArray *cellViewsToScan = self.gridView.scanningCells;
    UIView *previousScanningView = cellViewsToScan[self.scanningCoordinator.previousScanningIndex];
    [self scanningActivatedForView:previousScanningView];
}

- (void)rowColumnScanningViewTapped {
    if (self.scanningCoordinator.rowColumnScanningMode == kRowColumnScanningModeRow) {
        self.scanningCoordinator.rowColumnScanningMode = kRowColumnScanningModeColumn;
        [self.scanningCoordinator.scanningTimer fire];
    } else {
        NSArray *cellViewsToScan = [self scanningCellsForIndex:self.scanningCoordinator.previousScanningRowIndex];
        UIView *previousScanningView = cellViewsToScan[self.scanningCoordinator.previousScanningIndex];
        [self scanningActivatedForView:previousScanningView];
        
        [self clearPreviousScanningViewForColumn];
        self.scanningCoordinator.rowColumnScanningMode = kRowColumnScanningModeRow;
        self.scanningCoordinator.currentScanningIndex = 0;
        self.scanningCoordinator.previousScanningIndex = 0;
    }
}

#pragma mark - Scanning

- (void)startScanning {
    self.scanningView.hidden = NO;
    [self.scanningCoordinator startScanning];
}

- (void)stopScanning {
    self.scanningView.hidden = YES;
    [self clearPreviousScanningRow];
    [self clearPreviousScanningView];
    [self.scanningCoordinator stopScanning];
}

- (void)updateLinearScanning {
    NSArray *cellViewsToScan = self.gridView.scanningCells;
    if (!cellViewsToScan) { return; }

    // activate view for scanning
    UIView *viewToScan = cellViewsToScan[self.scanningCoordinator.currentScanningIndex];
    [viewToScan addScanningBorder];
}

- (void)updateRowColumnScanning {
    NSArray *cellViewsToScan = self.gridView.scanningCells;
    if (!cellViewsToScan) { return; }
    
    // activate view for scanning
    NSInteger rowIndex = self.scanningCoordinator.currentScanningRowIndex;
    self.scanningRow = [self scanningRowForIndex:rowIndex];
    
    [self.view addSubview:self.scanningRow];
}

- (void)updateRowColumnScanningModeColumn {
    NSArray *cellViewsToScan = [self scanningCellsForIndex:self.scanningCoordinator.previousScanningRowIndex];
    if (!cellViewsToScan) { return; }
    
    if (self.scanningCoordinator.currentScanningIndex < 0 || self.scanningCoordinator.currentScanningIndex >= cellViewsToScan.count) {
        self.scanningCoordinator.currentScanningIndex = 0;
    }
    
    // activate view for scanning
    UIView *viewToScan = cellViewsToScan[self.scanningCoordinator.currentScanningIndex];
    [viewToScan addScanningBorder];
}

- (void)clearPreviousScanningView {
    NSArray *cellViewsToScan = self.gridView.scanningCells;
    if (!cellViewsToScan) { return; }

    if (self.scanningCoordinator.currentScanningIndex < 0 || self.scanningCoordinator.currentScanningIndex >= cellViewsToScan.count) {
        self.scanningCoordinator.currentScanningIndex = 0;
    }
    
    UIView *previousScanningView = cellViewsToScan[self.scanningCoordinator.previousScanningIndex];
    if (!previousScanningView) { return; }
    [previousScanningView removeScanningBorder];
}

- (void)clearPreviousScanningViewForColumn {
    NSArray *cellViewsToScan = [self scanningCellsForIndex:self.scanningCoordinator.previousScanningRowIndex];
    if (!cellViewsToScan) { return; }
    
    if (self.scanningCoordinator.currentScanningIndex < 0 || self.scanningCoordinator.currentScanningIndex >= cellViewsToScan.count) {
        self.scanningCoordinator.currentScanningIndex = 0;
    }
    
    UIView *previousScanningView = cellViewsToScan[self.scanningCoordinator.previousScanningIndex];
    if (!previousScanningView) { return; }
    [previousScanningView removeScanningBorder];
}

- (void)clearPreviousScanningRow {
    if (!self.scanningRow) return;

    [self.scanningRow removeFromSuperview];
    self.scanningRow = nil;
}

- (void)scanningActivatedForView:(UIView *)view {
    if ([view isKindOfClass:[CellView class]]) {
        [(CellView *)view didTapView:nil];
    } else if ([view isKindOfClass:[UITextView class]]) {
        [self speak:nil];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSString *navigationControllerTitle;
    NSString *resource;
    
    if ([segue.identifier isEqualToString: @"YouTubeSegue"]) {
        navigationControllerTitle = @"You Tube";
        resource = [NSString stringWithFormat:kYouTube, self.dialogue.text];
    } else if ([segue.identifier isEqualToString: @"TwitterSegue"]) {
        navigationControllerTitle = @"Twitter";
        resource = [NSString stringWithFormat:kTwitter, self.dialogue.text];
    } else {
        navigationControllerTitle = @"Google";
        resource = [NSString stringWithFormat:kGoogle, self.dialogue.text];
    }
    
    NSString *encodedUrl = [resource stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL: [NSURL URLWithString: encodedUrl]];
    
    UINavigationController *navController = [segue destinationViewController];
    
    WebViewController *controller = [[navController viewControllers] firstObject];
    controller.request = requestURL;
    controller.title =  NSLocalizedString(navigationControllerTitle, nil);
}

- (void)navigateToWebControllerWithTitle:(NSString *)title urlString:(NSString *)urlString {
    NSString *encodedUrl = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:encodedUrl]];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *webNavController = [mainStoryboard instantiateViewControllerWithIdentifier:@"WebNavigationViewController"];

    WebViewController *controller = [[webNavController viewControllers] firstObject];
    controller.request = requestURL;
    controller.title =  NSLocalizedString(title, nil);
    
    [self presentViewController:webNavController animated:YES completion:nil];
}

#pragma mark - speech

- (IBAction)speak:(id)sender {
    [self.gridManager speak:self.dialogue.text];
}

#pragma mark - Notifications

- (void)cellTouched:(NSNotification *) notification {
    CellView *cellView = notification.userInfo[@"cell"];
    Cell *cell = cellView.cell;
    [self animateInView: cellView];
    
    if (cell.isLink) {
        [self processOvfLink: cell];
    } else {
        NSString *text = [NSString stringWithFormat:@"%@ %@", self.dialogue.text , cell.text];
        self.dialogue.text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}

- (void)unexpectedFormat:(NSNotification *) notification {
    NSDictionary *userInfo = notification.userInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName: kApplicationRaisedAnException object:self userInfo: userInfo];
}

- (void)animateInView:(UIView *)view {
    if (view) {
        view.alpha = 0.7f;
        [view setHidden:NO];
        [UIView animateWithDuration:0.25f animations:^{
            view.alpha = 1.0f;
        }];
        [view setNeedsDisplayInRect: view.bounds];
    }
}

- (void)changeToGrid:(Grid *)grid {
    [self clearGridView];
    self.gridView.grid = grid;
    [self animateInView:self.gridView];
    [self.gridView setNeedsLayout];
    
    BOOL isScanningSwitchOn = [[NSUserDefaults standardUserDefaults] boolForKey:kScanningStatusKey];
    if (isScanningSwitchOn) {
        [self stopScanning];
        [self startScanning];
    } else {
        [self stopScanning];
    }
}

// Clear up previous grid (release memory and remove notification observers)
- (void)clearGridView {
    NSArray *cellViewsToRemove = [self.gridView subviews];
    for (CellView *cellView in cellViewsToRemove) {
        [[NSNotificationCenter defaultCenter] removeObserver:cellView];
        [cellView removeFromSuperview];
    }
}

- (void)loadDefaultGrid:(NSNotification *)notification {
    NSManagedObjectContext *context = self.gridManager.managedObjectContext;
    if (context) {
        NSUInteger count = [Grid gridsCount: context];
        if (count) {
            Grid *grid = [Grid getGridByName:kDefaultGrid inManagedObjectContext:context];
            if (!grid) {
                grid = [Grid getGridByName:kDefaultOBZGrid inManagedObjectContext:context];
            }
            
            if (grid) {
                [self changeToGrid:grid];
            }
        }
    }
}

- (void)gridsNeedsSetup:(NSNotification *)notification {
    NSURL *downloadURL = notification.userInfo[@"url"];
    [self downloadGridFromUrl:downloadURL];
}

- (void)downloadGridFromUrl:(NSURL *)downloadURL {
    if ([GridManager isHostAvailable:downloadURL]) {
        self.pendingRequest = YES;
        __weak typeof(self) weakSelf = self;
        [self.gridManager buildDataFromURL:downloadURL completion:^(BOOL success){
            
            weakSelf.pendingRequest = NO;
            if(success){
                NSManagedObjectContext *managedObjectContext = [weakSelf.gridManager managedObjectContext];
                [managedObjectContext performBlock:^{
                    NSError *error;
                    [managedObjectContext save:&error];
                    if(!error){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf viewWillDisappear:true];
                            [weakSelf viewDidLoad];
                            [weakSelf viewWillAppear:true];
                            [weakSelf viewDidAppear:true];
                        });
                    }
                }];
            } else {
                // file format not recognised
                NSDictionary *errorDetails = @{
                                               @"error": NSLocalizedString(@"Download Format", nil),
                                               @"message": NSLocalizedString(@"Download format not recognised, please check your source", nil),
                                               };
                
                [[NSNotificationCenter defaultCenter] postNotificationName: kDownloadUnexpectedFormatErrorNotification object:self userInfo: errorDetails];
            }
        } error:^(NSError * _Nonnull error) {
            weakSelf.pendingRequest = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationRaisedAnException object:weakSelf userInfo:@{@"NSERROR" : error}];
        }];
    } else {
        [self internetConnectionRequired];
    }
}

#pragma mark - Process commands

- (NSString *)sanitizeString:(NSString *)string {
    NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSString *sanitizeString = [string stringByRemovingPercentEncoding];
    sanitizeString= [[sanitizeString  componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@" "];
    sanitizeString= [sanitizeString  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    sanitizeString= [sanitizeString  stringByRemovingPercentEncoding];
    
    return  sanitizeString;
}

- (void)processOvfLink:(Cell *)cell {
    if (cell.link) {
        if ([cell.link.linkRef containsString:@"ovf"]) {
            [self processLinkCommad:cell];
        } else {
            
            if(!cell.link.grid){
                // Attempt to set inverse relationship lazily
                Grid *grid = [Grid getGridByName:cell.link.linkRef inManagedObjectContext:self.gridManager.managedObjectContext];
                
                if (grid) {
                    cell.link.grid = grid;
                    NSError *error;
                    [cell.managedObjectContext save: &error];
                    if (error) {
                        // Failed to save core data context
                        [[NSNotificationCenter defaultCenter] postNotificationName: kApplicationRaisedAnException object:self userInfo: @{@"NSERROR" : error}];
                    }
                }
            }
            [self changeToGrid:cell.link.grid];
        }
    }
}

- (void)processLinkCommad:(Cell *)cell {
    NSArray *commands = [cell.link.linkRef componentsSeparatedByString:@","];
    for (NSString *command in commands) {
        
        NSArray *tokens = [[self sanitizeString: command] componentsSeparatedByString:@" "];
        
        if ([[tokens firstObject] isEqualToString:@"ovf"]) {
            if (tokens.count > 1) {
                NSString *command = [NSString stringWithFormat: @"%@:", tokens[1]];
                [self performCommand:command tokens:tokens];
            }
        } else if ([[tokens firstObject] isEqualToString:@"open"]) {
            if (tokens.count > 1) {
                NSString *command = [NSString stringWithFormat: @"%@:", tokens.firstObject];
                [self performCommand:command tokens:tokens];
            }
        }
    }
}

- (void)performCommand:(NSString *)command tokens:(NSArray *)tokens {
    @try {
        SEL aSelector = NSSelectorFromString(command);
        [self performSelector:aSelector withObject:tokens];
    } @catch (NSException *exception) {
    }
}

- (void)backspace:(NSArray *)tokens {
    self.dialogue.text = [self.dialogue.text substringToIndex:[self.dialogue.text length]-1];
}

- (void)blank:(NSArray *)tokens {
    // Do Nothing
}

- (void)clear:(NSArray *)tokens {
    self.dialogue.text = @"";
}

- (void)deleteword:(NSArray *)tokens {
    NSMutableArray *textTokens = [[NSMutableArray alloc] initWithArray: [self.dialogue.text componentsSeparatedByString:@" "]];
    [textTokens removeLastObject];
    NSString *text =@"";
    for (NSString *string in textTokens) {
        text =  [NSString stringWithFormat:@"%@ %@", text , string];
    }
    self.dialogue.text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (void)open:(NSArray *)tokens {
    if (tokens.count >= 2) {
        
        NSString *gridNameText = @"";
        for (int i=1; i < tokens.count; i++) {
            gridNameText = [NSString stringWithFormat:@"%@%@", gridNameText, tokens[i]];
        }
        gridNameText = [gridNameText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        Grid *grid = [Grid getGridByName:gridNameText inManagedObjectContext:self.gridManager.managedObjectContext];
        [self changeToGrid:(Grid *)grid];
    }
}

- (void)place:(NSArray *)tokens {
    if (tokens.count >= 3) {
        NSString *text = self.dialogue.text;
        for (int i=2; i<tokens.count;i++) {
            text = [NSString stringWithFormat:@"%@%@", text, tokens[i]];
        }
        self.dialogue.text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}

- (void)unfinnished:(NSArray *)tokens {
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

- (void)internetConnectionRequired {
    NSString *title = NSLocalizedString(@"Internet Connection", nil);
    NSString *message = NSLocalizedString(@"An internet connection is required to download resources. Please connect your device to a Wi-Fi network and try again.", nil);
    NSString *buttonTitle = NSLocalizedString(@"Close", nil);
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate showAlert:title message:message buttonText:buttonTitle];
}
@end
