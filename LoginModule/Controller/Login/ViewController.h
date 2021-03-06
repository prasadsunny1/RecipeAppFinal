//
//  ViewController.h
//  LoginModule
//
//  Created by indianic on 08/07/16.
//  Copyright © 2016 creativeIOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Google/SignIn.h>

@interface ViewController : UIViewController <GIDSignInUIDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtFEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtFPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;

@property (strong, nonatomic) IBOutlet UIButton *btnGoogleSignUp;

@property (weak, nonatomic) IBOutlet UIView *viewFacebookSignUp;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (weak, nonatomic) IBOutlet UIView *viewLoginField;

@property (strong,nonatomic) NSDictionary *googleSignInData;
@property (strong, nonatomic) IBOutlet UIImageView *imgAppLogo;

-(void)callGoogleLoginWebService : (nullable NSDictionary *) googleDict;
@end

