//
//  myprofilevc.m
//  LoginModule
//
//  Created by Meet Shah on 8/2/16.
//  Copyright © 2016 creativeIOS. All rights reserved.
//

#import "myprofilevc.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "AppDelegate.h"
#import "tblviewforsidebar.h"
#import "AFNetworking.h"
#import "tblviewforsidebar.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ChangePswdVC.h"

#define kWindowWidth            [[UIScreen mainScreen] bounds].size.width

@interface myprofilevc () <UIImagePickerControllerDelegate>
{
    NSString *aString;
    NSString *userId,*profilepic;
    UIImagePickerController *pickerView;
}
@end

@implementation myprofilevc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    userId =[AppDelegate sharedInstance].userId;
    profilepic =[AppDelegate sharedInstance].profilepic;
    
    _btnChangePassword.layer.cornerRadius=5.0;
    self.myimg.layer.cornerRadius = self.myimg.frame.size.height /2;
    _myimg.image=[UIImage imageNamed:@"userProfile"];
    self.myimg.layer.masksToBounds = YES;
    self.myimg.layer.borderWidth = 0;
    _lblUserName.text=[AppDelegate sharedInstance].userName;
    _lblUserEmail.text=[AppDelegate sharedInstance].userEmail;
    // Do any additional setup after loading the view.
    
    
    
    
    _myimg.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profilepic]]];
    
    
    pickerView =[UIImagePickerController new];
    pickerView.delegate=self;
    pickerView.allowsEditing=YES;
    [pickerView setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    
    
    
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






#pragma mark -Upload Profile Pic

-(void)uploadProfilePic{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    
     __block NSString *idOfImage;
    
    NSDictionary *headers = @{ @"x-apikey": @"18961ebc916a47e54dae5dcb273d407508bbe"
                               };
    
    
    
    
    
       NSData *fileData =UIImageJPEGRepresentation(_myimg.image, 0.8);
        
        
        
        
        
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"https://recipeapp-6bbd.restdb.io/media" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if(fileData){
                [formData appendPartWithFileData:fileData
                                            name:@"poi_pic"
                                        fileName:@"poiPic.jpg"
                                        mimeType:@"application/octet-stream"];
            }
            
        } error:nil];
        
        [request setHTTPMethod:@"POST"];
        [request setAllHTTPHeaderFields:headers];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
          
            NSLog(@"upload progress %f", uploadProgress.fractionCompleted);
        }
                                          completionHandler:^(NSURLResponse  * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                              
                                              if (error)
                                              {
                                              }
                                              else
                                              {
                                                  NSMutableDictionary *mutDic = (NSMutableDictionary*)responseObject;
                                                  NSLog(@"%@",mutDic[@"ids"][0]);
                                                  idOfImage=mutDic[@"ids"][0];
                                                  
                                                   aString =[NSString stringWithFormat:@"https://recipeapp-6bbd.restdb.io/media/%@",idOfImage];
                                                  
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                       [self changeProfilepic];
                                                   
                                                   });
                                                  
                                                  
                                                  
                                                  //here
                                              }
                                          }];
        
        [uploadTask resume];
        
    
}




#pragma mark -change profile pic upload



-(void)changeProfilepic{
    
    NSDictionary *headers = @{ @"x-apikey": @"18961ebc916a47e54dae5dcb273d407508bbe",
                               @"content-type": @"application/json",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"57c41260-46db-41ca-9399-cbccae2e2e59" };
    
    
    NSMutableDictionary *parameters=[NSMutableDictionary new];
    NSLog(@"image url  %@",aString);
    parameters = @{
                    @"profile_pic":aString}.mutableCopy;
    
    
    
    
    
    
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
                                                        [AppDelegate sharedInstance].profilepic=aString;
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


#pragma mark -button Action

- (IBAction)btnEditImageAction:(UIButton *)sender {
    
    [self.navigationController presentViewController:pickerView animated:YES completion:nil];
    
}


- (IBAction)btnSidebarMenu:(UIBarButtonItem *)sender {
    
 
     [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}


#pragma mark -picker View Delegate



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *chooseImage =info[UIImagePickerControllerEditedImage];
    _myimg.image=chooseImage;
    [self uploadProfilePic];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnChangePassword:(UIButton *)sender {
    ChangePswdVC *obj = (ChangePswdVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"ChangePswdVC"];
    [self.navigationController pushViewController:obj animated:YES];
   // [self.mm_drawerController setCenterViewController:obj withCloseAnimation:YES completion:nil];
}



@end
