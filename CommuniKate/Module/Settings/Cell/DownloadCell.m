//
//  DownloadCell.m
//  CommuniKate
//
//  Created by Ahmet Yalcinkaya on 23.12.2017.
//  Copyright © 2017 Flickaway Limited. All rights reserved.
//

#import "DownloadCell.h"

@interface DownloadCell()
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (nonatomic,strong) DownloadRequestedBlock downloadRequestedBlock;
@end

@implementation DownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSURL *url = [GridManager getJSONURL];
    if (url) {
        self.urlTextField.text = [NSString stringWithFormat:@"%@", url];
    }
}

- (void)setupCellWithDownloadRequestedBlock:(DownloadRequestedBlock)downloadRequestedBlock {
    self.downloadRequestedBlock = downloadRequestedBlock;
}

- (IBAction)download:(UIButton *)sender {
    NSArray *tokens = [self.urlTextField.text componentsSeparatedByString:@"://"];
    if ([[tokens firstObject] isEqualToString:@"https"]) {
        self.messageLabel.text = @" ";
        NSURL *url = [NSURL URLWithString:self.urlTextField.text];
        [[NSNotificationCenter defaultCenter] postNotificationName:kGridsNeedDownloadingNotification object:self userInfo:@{@"url": url}];
        self.downloadRequestedBlock();
    } else {
        self.messageLabel.text = NSLocalizedString(@"Resourse must be from a secure site, for example https://...", nil);
    }
}
@end
