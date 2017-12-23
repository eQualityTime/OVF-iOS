//
//  DownloadCell.h
//  CommuniKate
//
//  Created by Ahmet Yalcinkaya on 23.12.2017.
//  Copyright © 2017 Flickaway Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridManager.h"

@interface DownloadCell : UITableViewCell
typedef void (^DownloadRequestedBlock)(void);
- (void)setupCellWithDownloadRequestedBlock:(DownloadRequestedBlock)downloadRequestedBlock;
@end
