//
//  ViewController.h
//  CommuniKate
//
//  Created by Kalpesh Modha on 13/07/2017.
//   
//

#import <UIKit/UIKit.h>

@class GridManager;
@class Grid;
@class Cell;

@interface GridViewController : UIViewController

-(GridManager *) gridManager;
-(UITextView *)dialogue;
-(void)changeToGrid:(Grid *) grid;
-(void)processOvfLink:(Cell *) cell;
-(void)clearGridView;
-(NSString *)sanitizeString:(NSString *) string;
-(void)processLinkCommad:(Cell *) cell;
-(void)backspace:(NSArray *)tokens;
-(void)blank:(NSArray *)tokens;
-(void)clear:(NSArray *)tokens;
-(void)deleteword:(NSArray *)tokens;
-(void)open:(NSArray *)tokens;
-(void)place:(NSArray *)tokens;
-(void)unfinnished:(NSArray *)tokens;
@end
