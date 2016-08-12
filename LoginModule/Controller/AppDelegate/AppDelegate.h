//
//  AppDelegate.h
//  LoginModule
//
//  Created by indianic on 08/07/16.
//  Copyright © 2016 creativeIOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "MMExampleDrawerVisualStateManager.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) NSString *userId;
@property (strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSString *userEmail;
@property (strong,nonatomic) NSString *profilepic;
-(BOOL)isInternetAvailable;
+(AppDelegate*)sharedInstance;
-(void)showAlertInController:(UIViewController*)controller WithMessage:(NSString*)strMessage;
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error;
@end

