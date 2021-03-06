//
//  AppDelegate.m
//  LoginModule
//
//  Created by indianic on 08/07/16.
//  Copyright © 2016 creativeIOS. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Reachability.h"
#import "ViewController.h"
#import "Reachability.h"

@interface AppDelegate ()
{
    Reachability *aReachability;
}

@end

@implementation AppDelegate

+(AppDelegate*)sharedInstance
{
    return (AppDelegate*)[[UIApplication sharedApplication]delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //Facebook SignIn Code
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    
    // Google Sign in Code
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    //uitabbar appearences 
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"Button_3.png"]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Cochin-Italic" size:15.0f]}forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Cochin-Italic" size:15.0f]}forState:UIControlStateNormal];

    [self startReachability];
  
   //    [[UINavigationBar appearance] setTranslucent:YES];
//    [[[UINavigationController appearance] ]
    
    // Override point for customization after application launch.
    return YES;
}

-(void)showAlertInController:(UIViewController*)controller WithMessage:(NSString*)strMessage
{
    //alertView initializing
   UIAlertController  *alert  =[UIAlertController alertControllerWithTitle:@"Recipe" message:strMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [controller presentViewController:alert animated:YES completion:nil];
}

-(BOOL)isInternetAvailable{
    if(aReachability){
        NetworkStatus aState = [aReachability currentReachabilityStatus];
        if(aState != NotReachable){
            return YES;
        }
        return NO;
    }
    return NO;
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
    
    [FBSDKAppEvents activateApp];
    
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark -facebook Open Url

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    // Add any custom logic here.
    return handled;
}

#pragma mark -Google Open Url

//Implement the application:openURL:options: method of your app delegate. The method should call the handleURL method of the GIDSignIn instance, which will properly handle the URL that your application receives at the end of the authentication process.

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    
    
    if([[FBSDKApplicationDelegate sharedInstance] application:app
                                                             openURL:url
                                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]])
    {
        return  [[FBSDKApplicationDelegate sharedInstance] application:app
                                                                     openURL:url
                                                           sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                                  annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    else
    {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
}





-(void)startReachability{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    if(aReachability){
        [aReachability stopNotifier];
        aReachability = nil;
    }
    aReachability = [Reachability reachabilityForInternetConnection];
    [aReachability startNotifier];
}

@end
