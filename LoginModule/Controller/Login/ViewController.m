//
//  ViewController.m
//  LoginModule
//
//  Created by indianic on 08/07/16.
//  Copyright © 2016 creativeIOS. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AppDelegate.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "SignUpViewController.h"
#import <Google/SignIn.h>
#import "tblviewforsidebar.h"

#define kWindowWidth            [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()<GIDSignInDelegate>
{
    NSMutableDictionary *loginData;
    NSString *emailFromFacebook;
    NSString *emailFromGoogle;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareView];
    
    
    
    
    //
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor colorWithRed:159.0f/255.0f
 green:7.0f/255.0f blue:18.0f/255.0f alpha:1];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:159.0f/255.0f
                                                                             green:7.0f/255.0f blue:18.0f/255.0f alpha:1];
 
    //
    loginData =[NSMutableDictionary new];
    
    //Google Sign-In Code
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    
//    _txtFEmail.text = @"prasadsunny1@gmail.com";
//    _txtFPassword.text = @"qwerty@123";
    
    emailFromFacebook =[NSString new];
    
    // Uncomment to automatically sign in the user.
    //[[GIDSignIn sharedInstance] signInSilently];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -UIDesign 

-(void)prepareView{
    _imgAppLogo.layer.cornerRadius=(76/2);
    _imgAppLogo.layer.masksToBounds=YES;
    _btnSignUp.layer.cornerRadius=5.0;
    _viewLoginField.layer.cornerRadius=10.0;
    _viewLoginField.layer.shadowColor=[UIColor blackColor].CGColor;
}

#pragma mark -Social Login Button Click

- (IBAction)btnFbloginAction:(UIButton *)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login  logInWithReadPermissions: @[@"public_profile",@"email"]
                  fromViewController:self
                             handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                 if (error) {
                                     
                                     NSLog(@"%@",error);
                                     NSLog(@"Process error");
                                     
                                 } else if (result.isCancelled) {
                                     NSLog(@"Cancelled");
                                 } else {
                                     NSLog(@"%@",result);
                                     NSLog(@"Logged in");
                                     
                                     if ([result.grantedPermissions containsObject:@"email"])
                                     {
                                         if ([FBSDKAccessToken currentAccessToken])
                                         {
                                             [self getFBInfo];
                                         }
                                         
                                     }
                                     
                                 }
                             }];
}

- (IBAction)btnGoogleLoginAction:(UIButton *)sender {
    
    [[GIDSignIn sharedInstance] signIn];
    [GIDSignIn sharedInstance].delegate = self;

}

#pragma mark -Google SignIn Delegate


//In the app delegate, implement the GIDSignInDelegate protocol to handle the sign-in process by defining the following methods:

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    
    
    NSDictionary *aDict = @{ @"userId" : userId ,
                             @"idToken" : idToken,
                             @"FullName" : fullName,
                             @"givenName" : givenName,
                             @"familyName" :familyName,
                             @"email" :email
                             };
    
    
    
    [AppDelegate sharedInstance].profilepic=nil;
    [AppDelegate sharedInstance].userName=aDict[@"FullName"];
    [AppDelegate sharedInstance].userEmail=aDict[@"email"];
    
    
    
    
    [self callGoogleLoginWebService:aDict];
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}


#pragma mark -login Authentication



-(void)callLoginWebService{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"x-apikey": @"18961ebc916a47e54dae5dcb273d407508bbe",@"cache-control": @"no-cache",
    @"postman-token": @"75f6a352-914f-954f-19f7-b29dddaeade9" };


//    NSString *email=@"email";
//    NSString *password=@"password";
    NSString *url =[NSString stringWithFormat:@"https://recipeapp-6bbd.restdb.io/rest/profile?q={\"email\":\"%@\",\"password\":\"%@\"}",_txtFEmail.text,_txtFPassword.text];
    
    NSLog(@"\n\n URL :    %@",url);
    NSLog(@"utf %@",[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    
    NSURL *myurl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myurl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    

    NSLog(@"\n\n MYURL :   %@",myurl);
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSLog(@"%@",data);
                                                        NSArray *aArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                                                        NSLog(@" Dict : %@",aArray);
                                                        
                                                        if(aArray.count){
                                                        
                                                        NSDictionary *aDict = aArray[0];
                                                        
                                                       
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            if([aDict[@"email"] isEqualToString:@"prasadsunny1@gmail.com" ]){
                                                                
                                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                
                                                                //[self performSegueWithIdentifier:@"LoginSuccessSegue" sender:nil];
                                                                [self pushToDrawer];

                                                                
                                                            }else {
                                                                
                                                                [MBProgressHUD hideHUDForView:self.view animated:YES];

                                                            }
                                                            
                                                        });
                                                            
                                                            [AppDelegate sharedInstance].userId=aDict[@"_id"];
                                                            [AppDelegate sharedInstance].userName=aDict[@"name"];
                                                            [AppDelegate sharedInstance].profilepic=aDict[@"profile_pic"];
                                                            [AppDelegate sharedInstance].userEmail=aDict[@"email"];
                                                            
                                                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                            NSLog(@"%@", httpResponse);
                                                        }else{
                                                            
                                                            NSLog(@" Wrong Username or Password");
                                                            dispatch_async(dispatch_get_main_queue(), ^{

                                                            [MBProgressHUD hideHUDForView:self.view animated:true];
                                                            });
                                                        }
                                                      
                                                    }
                                                }];
    [dataTask resume];
}







//Facebook login WebService

-(void)callFacebookLoginWebService: (nullable NSDictionary *) FacebookDict{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"x-apikey": @"18961ebc916a47e54dae5dcb273d407508bbe",@"cache-control": @"no-cache",
                               @"postman-token": @"75f6a352-914f-954f-19f7-b29dddaeade9" };
    
    
    //    NSString *email=@"email";
    //    NSString *password=@"password";
    NSString *url =[NSString stringWithFormat:@"https://recipeapp-6bbd.restdb.io/rest/profile?q={\"email\":\"%@\"}",emailFromFacebook];
    
    NSLog(@"\n\n URL :    %@",url);
    NSLog(@"utf %@",[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    
    NSURL *myurl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myurl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    
    
    NSLog(@"\n\n MYURL :   %@",myurl);
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSLog(@"%@",data);
                                                        NSArray *aArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                                                        NSLog(@" Dict : %@",aArray);
                                                        
                                                        if(aArray.count){
                                                            
                                                            NSDictionary *aDict = aArray[0];
                                                            
                                                            
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                if([aDict[@"email"] isEqualToString:emailFromFacebook]){
                                                                    [AppDelegate sharedInstance].userId=aDict[@"_id"];
                                                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                    
                                                                   // [self performSegueWithIdentifier:@"LoginSuccessSegue" sender:nil];
                                                                    [self pushToDrawer];

                                                                    
                                                                }
                                                                
                                                            });
                                                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                            NSLog(@"%@", httpResponse);
                                                        }else{
                                                            
                                                            
                                                            dispatch_async(dispatch_get_main_queue(),^{
                                                            
                                                                
                                                                SignUpViewController *obj=[SignUpViewController new];
                                                                [obj addUser:FacebookDict];
                                                                
                                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                
                                                                [self pushToDrawer];

                                                            
                                                            
                                                            
                                                            });
                                                            
                                                            
                                                          
                                                            
                                                            NSLog(@" Wrong Username or Password");
                                                        }
                                                        
                                                    }
                                                }];
    [dataTask resume];
}


//google Sign In Web Service




-(void)callGoogleLoginWebService : (nullable NSDictionary *) googleDict{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"x-apikey": @"18961ebc916a47e54dae5dcb273d407508bbe",@"cache-control": @"no-cache",
                               @"postman-token": @"75f6a352-914f-954f-19f7-b29dddaeade9" };
    
    
    //    NSString *email=@"email";
    //    NSString *password=@"password";
    
    emailFromGoogle =googleDict[@"email"];
    NSString *url =[NSString stringWithFormat:@"https://recipeapp-6bbd.restdb.io/rest/profile?q={\"email\":\"%@\"}",emailFromGoogle];
    
    NSLog(@"\n\n URL :    %@",url);
    NSLog(@"utf %@",[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    
    NSURL *myurl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myurl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    
    
    NSLog(@"\n\n MYURL :   %@",myurl);
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        
                                                        NSArray *aArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                                                        NSLog(@" Dict : %@",aArray);
                                                        
                                                        if(aArray.count){
                                                            
                                                            NSDictionary *aDict = aArray[0];
                                                            
                                                            
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                
                                                                if([aDict[@"email"] isEqualToString:emailFromGoogle ]){
                                                                    
//                                                                    [AppDelegate sharedInstance].profilepic=aDict[@"profile_pic"];
                                                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                    
                                                                    
//                                                                    NSLog(@"successs");
//                                                                    [self performSegueWithIdentifier:@"LoginSuccessSegue" sender:nil];

                                                                    [self pushToDrawer];
                                                                    
                                                                }
                                                             
                                                                
                                                            });
                                                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                            NSLog(@"%@", httpResponse);
                                                        }else{
                                                            
                                                            NSLog(@" Wrong Username or Password");
                                                            NSLog(@"google user not found in our db ,Registering him now");
                                                            SignUpViewController *obj=[SignUpViewController new];
                                                            [obj addUser:googleDict];
                                                            

                                                        }
                                                        

                                                    }
                                                }];
    [dataTask resume];
}

-(void)pushToDrawer
{
    UITabBarController *obTabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabbar"];
    
    tblviewforsidebar *objRight = [self.storyboard instantiateViewControllerWithIdentifier:@"tblviewforsidebar"];
    
    MMDrawerController *drawerController = [[MMDrawerController alloc] initWithCenterViewController:obTabbar leftDrawerViewController:nil rightDrawerViewController:objRight];
    
    // [drawerController setMaximumLeftDrawerWidth:MIN(200, (kWindowWidth - 80)) ];
    [drawerController setMaximumRightDrawerWidth:MIN(220, (kWindowWidth - 80)) ];
    [drawerController setShowsShadow:YES];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.navigationController pushViewController:drawerController animated:YES];
}


#pragma mark button Action


- (IBAction)btnForgotPasswordAction:(UIButton *)sender {
    
    
    
}





- (IBAction)btnLoginAction:(UIButton *)sender {
    
//    if([[AppDelegate sharedInstance] isInternetAvailable])
//    {
        if ([self NSStringIsValidEmail:_txtFEmail.text]) {
                [self callLoginWebService];
        }
        else{
            
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Invalid Email" message:@"Please check email you have entered" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
//    }
//    else
//    {
//        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Oops" message:@"Internet Not Available" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//        [alert addAction:okAction];
//        [self presentViewController:alert animated:YES completion:nil];
//        
//    }

    
}


#pragma mark -validations

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(IBAction)logout:(UIStoryboardSegue*)sender
{
    
}

-(void)getFBInfo{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, picture.type(large), email, birthday, bio,location"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error)
         {
             NSLog(@"Result = %@",result);
             
             emailFromFacebook = result[@"email"];
             [AppDelegate sharedInstance].profilepic=result[@"picture"][@"data"][@"url"];
             [AppDelegate sharedInstance].userName=result[@"name"];
             [AppDelegate sharedInstance].userEmail=result[@"email"];
             
             
             NSDictionary *aDict =@{@"FullName":result[@"name"],
                                              @"email":result[@"email"],@"fbidToken":result[@"id"],@"profilepic":result[@"picture"][@"data"][@"url"]};
             
            
             [self callFacebookLoginWebService:aDict];
            
                     }
         else
         {
             NSLog(@"Error %@",error);
            
         }
     }];
}

@end
