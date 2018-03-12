//
//  GridView.h
//  CommuniKate
//
//  Created by Kalpesh Modha on 19/07/2017.
//   
//

#import <UIKit/UIKit.h>
#import "Grid+CoreDataClass.h"

@interface GridView : UIView
@property (strong, nonatomic, nonnull) Grid *grid;
@property (strong, nonatomic, nonnull) NSArray<UIView *> *scanningCells;
@property (strong, nonatomic, nonnull) NSArray<UIView *> *linearScanningCells;
@property (strong, nonatomic) UITextView * _Nullable dialogue;

@end
