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
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self.webView loadRequest:_request];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions

- (IBAction)close:(id)sender {
    self.webView = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
