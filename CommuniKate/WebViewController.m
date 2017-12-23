//
//  WebViewController.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 21/07/2017.
//   
//

#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.webView loadRequest:self.request];
}

#pragma mark - Actions

- (IBAction)close:(id)sender {
    self.webView = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
