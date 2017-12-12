//
//  AppDelegate.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 13/07/2017.
//   
//

#import "AppDelegate.h"
#import "GridManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(applicationException:) name: kApplicationRaisedAnException object: nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

-(void)applicationException:(NSNotification *) notification
{
    NSString *alertTitle = NSLocalizedString(@"Application Error", nil);
    NSString *alertMessage=@"";
    
    id userInfo = notification.userInfo[@"NSERROR"];
    if ([userInfo isKindOfClass:[NSError class]])
    {
        NSError *error = userInfo;
        if(error)
        {
            alertMessage = [NSString stringWithFormat:@"%@\n", error.localizedDescription];
        }
    }
    else
    {
        // custom error format
        alertTitle = NSLocalizedString(notification.userInfo[@"error"], nil);
        alertMessage =  [NSString stringWithFormat:@"%@", NSLocalizedString(notification.userInfo[@"message"], nil)];
    }
    
    [self showAlert: alertTitle message:alertMessage buttonText:@"Cancel"];
}

-(void)showAlert:(NSString *) title message:(NSString *) message buttonText:(NSString *) text{
    
    NSString *buttonTitle = NSLocalizedString(text, nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //Create the actions.
    UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleCancel handler:nil];
    
    //Add the actions.
    [alertController addAction:action];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}


@end
