//
//  AppDelegate.m
//  tinder
//
//  Created by Ren He on 2/12/16.
//  Copyright © 2016 Ren He. All rights reserved.
//

#import "AppDelegate.h"
#import "OnboardingViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "MainViewController.h"

@interface AppDelegate (){
    
    MainViewController *mainVC;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [Parse setApplicationId:@"9M1NfC5lh6pWQGuSK59ahtC6XSUpxh9CMO79Zrpl" clientKey:@"s1K7EY2FEyjTVQ4lkTGQwg7I33FajWNkHyr3staY"];
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    //----------------------------------------------------------------------------------------------------------
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([userDefaults boolForKey:@"isLoggedIn"]) {
        OnboardingViewController *onboardVC = [[OnboardingViewController alloc] init];
        [onboardVC LogIned];
    }
    else
    {
        OnboardingViewController *onboardVC = [[OnboardingViewController alloc] init];
        onboardVC.view.backgroundColor = [UIColor clearColor];
        _navigationController = [[UINavigationController alloc] initWithRootViewController:onboardVC];
        [_navigationController.navigationBar setTranslucent:NO];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = _navigationController;
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

@end
