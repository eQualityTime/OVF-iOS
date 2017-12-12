//
//  DownloadViewController.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 17/08/2017.
 

#import "DownloadViewController.h"
#import "GridManager+Settings.h"

@interface DownloadViewController ()
@property (weak, nonatomic) IBOutlet UITextField *url;
@property (weak, nonatomic) IBOutlet UILabel *message;

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *url = [GridManager getJSONURL];
     if(url){
        self.url.text = [NSString stringWithFormat:@"%@", url];
    }
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)download:(id)sender {
    
    NSArray *tokens = [self.url.text componentsSeparatedByString:@"://"];
    if([[tokens firstObject] isEqualToString:@"http"]){
        NSURL *url = [NSURL URLWithString:self.url.text];
        [self.delegate downloadViewController: self downloadFromURL:url];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        self.message.text = NSLocalizedString(@"Resourse must be from a secure site, for example https://...", nil);
    }
}

@end
