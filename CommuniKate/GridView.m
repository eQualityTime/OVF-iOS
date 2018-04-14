//
//  GridView.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 19/07/2017.
//   
//

#import "GridView.h"
#import "CellView.h"
#import "GridManager.h"

@implementation GridView

- (void)drawRect:(CGRect)rect {
    // Clear all subviews
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (self.grid) {
        
        CGFloat cellWidth = rect.size.width / 5.0f;
        CGFloat cellHeight = rect.size.height / 5.0f;
        
        if (cellHeight > cellWidth) {
            cellHeight = cellWidth;
        }
        
        NSMutableArray *scanningCellList = [NSMutableArray new];
        
        for (Cell *cell in self.grid.cells) {
            
            CGRect cellRect = CGRectZero;
            cellRect.origin.x = [cell.x floatValue] * cellWidth;
            cellRect.origin.y = [cell.y floatValue] * cellHeight;
            cellRect.size.width = cellWidth;
            cellRect.size.height = cellHeight;
            // cellRect = CGRectInset(cellRect, 1.0f, 1.0f); // margin
            CellView *view = [[CellView alloc] initWithFrame:cellRect];
            view.cell = cell;

            [self addSubview:view];
            [scanningCellList addObject:view];
        }
        
        scanningCellList = [[scanningCellList sortedArrayUsingComparator:^NSComparisonResult(CellView *a, CellView *b) {
            double first = ([a.cell.y floatValue] * 5.0) + [a.cell.x floatValue];
            double second = ([b.cell.y floatValue] * 5.0) + [b.cell.x floatValue];
            return first > second;
        }] mutableCopy];
        
        if (self.dialogue) {
            self.dialogue.frame = CGRectMake(cellWidth, 0, cellWidth*3, cellHeight);
            [self addSubview: self.dialogue];
            if (scanningCellList.count > 1) {
                [scanningCellList insertObject:self.dialogue atIndex:1];
            }
        }
        
        self.scanningCells = scanningCellList;
        self.cellHeight = cellHeight;
        
        UIButton *speakButton = [UIButton buttonWithType:UIButtonTypeSystem];
        speakButton.frame = self.dialogue.frame;
        [speakButton addTarget:self action:@selector(speak:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:speakButton];
    }
}

- (void)speak:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSpeakTextNotification object:nil];
}

@end
