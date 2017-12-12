//
//  AppDelegate.h
//  CommuniKate
//
//  Created by Kalpesh Modha on 13/07/2017.
//   
//

#import <UIKit/UIKit.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * _Nullable window;
-(void)applicationException:(NSNotification *_Nullable) notification;
-(void)showAlert:(NSString *_Nonnull) title message:(NSString *_Nonnull) message buttonText:(NSString *_Nonnull) text;
@end

