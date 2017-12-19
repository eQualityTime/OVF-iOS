//
//  DownloadViewController.h
//  CommuniKate
//
//  Created by Kalpesh Modha on 17/08/2017.
 

#import <UIKit/UIKit.h>

@class DownloadViewController;

@protocol DownloadViewControllerDelegate
- (void)downloadViewController:(DownloadViewController *)controller downloadFromURL:(NSURL *)url;
@end

@interface DownloadViewController : UIViewController
@property (weak, nonatomic) id <DownloadViewControllerDelegate> delegate;
@end
