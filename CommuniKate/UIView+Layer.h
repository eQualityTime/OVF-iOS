//
//  UIView+Layer.h
//  OakMed
//
//  Created by Kalpesh Modha on 09/12/2016.
 
//

#import <UIKit/UIKit.h>

#define IB_DESIGNABLE
@interface UIView (Layer)
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@end
