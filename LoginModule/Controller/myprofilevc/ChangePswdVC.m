//
//  ChangePswdVC.m
//  LoginModule
//
//  Created by indianic on 03/08/16.
//  Copyright © 2016 creativeIOS. All rights reserved.
//

#import "ChangePswdVC.h"
#import "AppDelegate.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ChangePswdVC ()
{
    NSString *userId;
}

@end

@implementation ChangePswdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _btnSavePassword.layer.cornerRadius=5.0;
    userId =[AppDelegate sharedInstance].userId;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -ChangePassword;

-(void)checkPassword{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"x-apikey": @"18961ebc916a47e54dae5dcb273d407508bbe",@"cache-control": @"no-cache",
                               @"postman-token": @"75f6a352-914f-954f-19f7-b29dddaeade9" };
    
    

    NSString *url =[NSString stringWithFormat:@"https://recipeapp-6bbd.restdb.io/rest/profile?q={\"_id\":\"%@\"}",userId];
    
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
                                                                
                                                                if([aDict[@"_id"] isEqualToString:userId ]){
                                                                    
                                                                    [self ChangePassword];
                                                                    
                                                                    
                                                                    
                                                                }else {
                                                                    
                                                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                    
                                                                }
                                                                
                                                            });
                                                            
                                                            [AppDelegate sharedInstance].userId=aDict[@"_id"];
                                                            [AppDelegate sharedInstance].userName=aDict[@"name"];
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



-(void)ChangePassword{
    
    NSDictionary *headers = @{ @"x-apikey": @"18961ebc916a47e54dae5dcb273d407508bbe",
                               @"content-type": @"application/json",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"57c41260-46db-41ca-9399-cbccae2e2e59" };
    
    
    NSMutableDictionary *parameters=[NSMutableDictionary new];
    
        parameters = @{
                        @"password":_txtFNewPassword.text}.mutableCopy;
    
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    
      NSString *url =[NSString stringWithFormat:@"https://recipeapp-6bbd.restdb.io/rest/profile/%@",userId];
    
     NSURL *myurl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myurl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    
    [request setHTTPMethod:@"PUT"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                            
                                                        NSLog(@"success");
                                                        
                                                    });
                                                    
                                                    
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                    }
                                                }];
    [dataTask resume];

    
}
#pragma mark -change password Button Action

- (IBAction)btnChangePassword:(UIButton *)sender {
    if(![_txtFNewPassword.text isEqualToString:_txtFcurrentPassword.text]){
    [self checkPassword];
    
    }
    
}



#pragma mark -bar button Action

- (IBAction)btnmenu:(UIBarButtonItem *)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

@end
