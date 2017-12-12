// 
// UIView+Animation.m
// Accounts
// 
// Created by Kalpesh Modha on 08/03/2015.
 
// 

#import "UIView+Animation.h"

@implementation UIView (Animation)

+(CATransition *)fadeTransition
{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.6;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
    return animation;
}

@end
