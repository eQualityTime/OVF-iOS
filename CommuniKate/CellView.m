//
//  Cell.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 20/07/2017.
//   
//

#import "CellView.h"
#import "Cell+CoreDataClass.h"
#import "Image+CoreDataClass.h"
#import "GridManager.h"
#import "GridManager+Store.h"

@implementation CellView

+(NSString *)defaultFont
{
    return @"System";
}

+(UIFont *)font{
    CGFloat fontSize = [UIFont preferredFontForTextStyle:UIFontTextStyleBody].pointSize;
    return [UIFont fontWithName: [CellView defaultFont] size: fontSize];
}


- (void)drawRect:(CGRect)rect {
    UITapGestureRecognizer *singleFingerTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
    [self addGestureRecognizer:singleFingerTap];
    
    UIFont *font = [CellView font];
    
    CGRect cellRect = rect;
    
    UIColor *color = [GridManager colorFromString: _cell.color];
    [color setFill];
    
    UIRectFill(cellRect);
    
    CGRect cellContentRect = CGRectInset(cellRect, 5.0f, 10.0f);
    
    CGRect labelRect = CGRectZero;
    CGFloat fontSize = [UIFont preferredFontForTextStyle:UIFontTextStyleBody].pointSize;
    CGRectDivide(cellContentRect, &labelRect , &cellContentRect, fontSize, CGRectMinYEdge);
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame: labelRect];
    
    nameLabel.adjustsFontSizeToFitWidth=YES;
    nameLabel.minimumScaleFactor=0.5;
    
    [nameLabel setTextAlignment: NSTextAlignmentCenter];
    [nameLabel setFont: font];
    [nameLabel setTextColor: [UIColor blackColor]];
    nameLabel.text = _cell.text;
    
    [self addSubview: nameLabel];
    
    if(_cell.hasImage){
        CGRect imageRect = CGRectInset(cellContentRect, 8.0f, 8.0f);
        [GridManager getImageForCell: _cell inView:self rect: imageRect];
    }

    
    if(_cell.isLink){
        
        CGRect triangle = CGRectZero;
        CGFloat triangleWidth = 25.0f;
        
        triangle.size.width = triangleWidth;
        triangle.size.height = triangleWidth;
        triangle.origin.x = rect.size.width - triangle.size.width;
        triangle.origin.y =  rect.size.height - triangle.size.height;
        
        UIBezierPath *trianglePath = [UIBezierPath bezierPath];
        
        // Set the starting point of the shape.
        [trianglePath moveToPoint:CGPointMake(triangle.origin.x + triangleWidth, triangle.origin.y)];
        
        // Draw the lines.
        [trianglePath addLineToPoint:CGPointMake(triangle.origin.x + triangleWidth, triangle.origin.y +triangleWidth)];
        [trianglePath addLineToPoint:CGPointMake(triangle.origin.x, triangle.origin.y +triangleWidth)];
        [trianglePath closePath];
        
        [[UIColor darkGrayColor] setFill];
        [[UIColor darkGrayColor] setStroke];
        
        [trianglePath fill];
        [trianglePath stroke];
    }
}

-(void)didTapView:(UITapGestureRecognizer *)recognizer{
    [[NSNotificationCenter defaultCenter] postNotificationName: kDidTapViewNotification object:nil userInfo: @{@"cell": self}];
}


@end

