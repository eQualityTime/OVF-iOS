//
//  UIView+Layer.m
//  OakMed
//
//  Created by Kalpesh Modha on 09/12/2016.
 
//

#import "UIView+Layer.h"

@implementation UIView (Layer)

@dynamic cornerRadius, borderColor, borderWidth;

-(void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    [self.layer setBorderWidth:borderWidth];
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    [self.layer setCornerRadius:cornerRadius];
}

@end
