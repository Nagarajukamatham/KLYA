//
//  AppDelegate.m
//  PiggyBank
//
//  Created by Nagaraju on 16/03/18.
//  Copyright © 2018 Nagaraju. All rights reserved.
//

#import "AppDelegate.h"
#import "PBPinViewController.h"
#import "SplashViewController.h"
@interface AppDelegate (){
    NSUserDefaults *defaults;
}

@end

@implementation AppDelegate


- (SplashViewController *)splashController {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    return [mainStoryboard instantiateViewControllerWithIdentifier:@"SplashViewController"];
}

- (PBPinViewController *)pinController {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    return [mainStoryboard instantiateViewControllerWithIdentifier:@"PBPinViewController"];
}

- (UINavigationController *)gotoSplashViewController {
    return [[UINavigationController alloc] initWithRootViewController:[self splashController]];
}

- (UINavigationController *)gotoPinViewController {
    return [[UINavigationController alloc] initWithRootViewController:[self pinController]];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    defaults = [NSUserDefaults standardUserDefaults];
    [self checkAppWayNgo];
    return YES;
}

//checking the app way and goto PIN screen or other screen
-(void)checkAppWayNgo{
    NSData *loginData = [defaults objectForKey:@"loginResp"];
    NSDictionary *loginDict = [NSKeyedUnarchiver unarchiveObjectWithData:loginData];
    UINavigationController *navigationController;
    if ([[defaults objectForKey:@"isBackground"] isEqualToString:@"yes"] && loginDict != NULL) {
        [defaults setObject:@"no" forKey:@"isBackground"];
        navigationController = [self gotoPinViewController];
    }else{
        navigationController = [self gotoSplashViewController];
    }
    navigationController.navigationBarHidden=YES;
    self.window.rootViewController = navigationController;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [defaults setObject:@"yes" forKey:@"isBackground"];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self checkAppWayNgo];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
