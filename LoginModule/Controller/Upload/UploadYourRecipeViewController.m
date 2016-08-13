//
//  UploadYourRecipeViewController.m
//  LoginModule
//
//  Created by indianic on 22/07/16.
//  Copyright © 2016 creativeIOS. All rights reserved.
//

#import "UploadYourRecipeViewController.h"
#import "AddIngredientViewController.h"
#import "AddStepsViewController.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "AFNetworking.h"


@interface UploadYourRecipeViewController ()
{
    
    UIImagePickerController *imagepicker;
    NSMutableArray  *arrAllRecipeData;
    NSMutableDictionary *dictTempRecipe;
    NSMutableArray *arrMutIngredient;
    NSMutableArray *arrMutSteps;
    NSMutableArray *arrCopyOfAllRecipeData;
    NSMutableDictionary *dictStepToSend;
    NSMutableDictionary *dictIngredientstosend;
    NSMutableDictionary *dictIngredientQuantityToSend;
    NSArray *pickerCategory;
    NSMutableString *strRecipeCategory;
    NSString *user,*userid;


}
@property (strong, nonatomic) IBOutlet UIPickerView *uiPickerOutlet;
@property (strong, nonatomic) IBOutlet UIView *vieww;

@property (strong, nonatomic) IBOutlet UITextField *txtFCategory;

@end

@implementation UploadYourRecipeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    strRecipeCategory =[NSMutableString new];
    dictIngredientstosend =[[NSMutableDictionary alloc]init];
    dictIngredientQuantityToSend =[[NSMutableDictionary alloc]init];
    dictStepToSend =[[NSMutableDictionary alloc]init];
    arrAllRecipeData=[NSMutableArray new];
    dictTempRecipe=[NSMutableDictionary new];
    arrMutIngredient=[NSMutableArray new];
    arrMutSteps=[NSMutableArray new];
    
    imagepicker=[[UIImagePickerController alloc]init];
    imagepicker.delegate=self;
    [imagepicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    [imagepicker setAllowsEditing:YES];
    
    
    user=[AppDelegate sharedInstance].userName;
    userid=[AppDelegate sharedInstance].userId;
    
    pickerCategory= @[@"punjabi", @"chinese", @"south Indian", @"gujarati", @"baked"];
// [_sliderTime addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];//    AddIngredientViewController *objaddIngredient =[[AddIngredientViewController alloc]init];
//    objaddIngredient.delegate=self;
    
    
    
    [_vieww removeFromSuperview];
    _txtFCategory.inputView=_vieww;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"AddIngredientViewControllerSegue"])
    {
        //Getting Values in Dictionary
        
        AddIngredientViewController *obj = segue.destinationViewController;
        [obj set_completionHandler:^(NSMutableArray *mutArr) {
            
            NSLog(@"%@",mutArr);
            arrMutIngredient=mutArr;
        }];
    }
    if ([segue.identifier isEqualToString:@"AddStepsViewControllerSegue"]) {
        
        AddStepsViewController *obj = segue.destinationViewController;
        [obj set_completionHandler:^(NSMutableArray *mutArr) {
            
            NSLog(@"%@",mutArr);
            arrMutSteps=mutArr;
        }];

    }
}



#pragma mark -Button Actions



- (IBAction)btnAddCoverImage:(UIButton *)sender {
    
    [self.navigationController presentViewController:imagepicker animated:true completion:nil];
}


- (IBAction)btnAddIngredientsAction:(UIButton *)sender {
    
    
}

- (IBAction)btnAddVideoAction:(UIButton *)sender {
    for (int i=1; i<=[arrCopyOfAllRecipeData[0][@"steps"] count]; i++) {
        NSMutableDictionary *adict=[[NSMutableDictionary alloc]init];
        [adict setObject:arrCopyOfAllRecipeData[0][@"steps"][i-1][@"stepNumber"] forKey:@"no"];
        [adict setObject:arrCopyOfAllRecipeData[0][@"steps"][i-1][@"stepImage"] forKey:@"image"];
        [adict setObject:arrCopyOfAllRecipeData[0][@"steps"][i-1][@"stepDescription"] forKey:@"discription"];
        
        [dictStepToSend setObject:adict forKey:[NSString stringWithFormat:@"step%d",i]];
        
        
    }
    NSLog(@"dictTosend :  %@",dictStepToSend);
    for (int i=0; i<[arrCopyOfAllRecipeData[0][@"ingredient"] count]; i++) {
        [dictIngredientstosend setObject:arrCopyOfAllRecipeData[0][@"ingredient"][i][@"name"] forKey:[NSString stringWithFormat:@"%d",i]];
    
    
    }
    NSLog(@"ingredients to send %@",dictIngredientstosend);
    
    
    
    //dictIngredientstosend
    for (int i=0; i<[arrCopyOfAllRecipeData[0][@"ingredient"] count]; i++) {
        [dictIngredientQuantityToSend setObject:arrCopyOfAllRecipeData[0][@"ingredient"][i][@"quantity"] forKey:[NSString stringWithFormat:@"%d",i]];
        
        
    }
    NSLog(@"ingredients to send %@",dictIngredientQuantityToSend);

    ///
    [self sendData];
    
}

- (IBAction)btnAddStepsAction:(UIButton *)sender {
}


- (IBAction)btnUploadAction:(UIButton *)sender {
    [self CollectData];
    
   
    NSLog(@"all recipe data  \n %@",arrAllRecipeData);
    
    arrCopyOfAllRecipeData=arrAllRecipeData;
    NSLog(@"copy of all recipe data  \n %@",arrCopyOfAllRecipeData);
    
//    [self uploadImageAndReturnIdwithCoverImage:(id)arrCopyOfAllRecipeData[0][@"coverimage"]];
    [self uploadAllImages];
    
    
}

#pragma mark -Delegate Methods


-(void)sendData{
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrCopyOfAllRecipeData[0][@"ingredient"]
//                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
//                                                         error:&error];
//    
//    if (! jsonData) {
//        NSLog(@"Got an error: %@", error);
//    } else {
//        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    }
    
    NSDictionary *headers = @{ @"x-apikey": @"18961ebc916a47e54dae5dcb273d407508bbe",
                               @"content-type": @"application/json",
                               @"cache-control": @"no-cache",
                               
                               @"postman-token": @"1701ee21-7499-1b11-eccb-44d5d6c2ab84" };
    NSDictionary *parameters = @{ @"author": arrCopyOfAllRecipeData[0][@"author"],
                                  @"coverimage": arrCopyOfAllRecipeData[0][@"coverimage"],
                                  @"nonveg": arrCopyOfAllRecipeData[0][@"nonveg"],
                                  @"recipe_discription": arrCopyOfAllRecipeData[0][@"recipe_discription"],
                                  @"serves": arrCopyOfAllRecipeData[0][@"serves"],
                                  @"time": @"15",
                                  @"ingredient": dictIngredientstosend,
                                  @"ingredient_quantity":dictIngredientQuantityToSend,
                                  @"video": @"link",
                                  @"steps": dictStepToSend,
                                  @"location": @"india",
                                  @"name":arrCopyOfAllRecipeData[0][@"name"],
                                  @"category" :arrCopyOfAllRecipeData[0][@"category"],
                                  @"userid":userid};
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://recipeapp-6bbd.restdb.io/rest/recipes"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        
                                                        NSArray *aArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                                                        NSLog(@" Dict : %@",aArray);

                                                    }
                                                }];
    [dataTask resume];
    
}

#pragma mark -upload all images


-(void)uploadAllImages{
    __block  double progress=0;

    NSMutableData *fileData;
    __block NSString *idOfImage;
    
    NSDictionary *headers = @{ @"x-apikey": @"18961ebc916a47e54dae5dcb273d407508bbe"
                               };
   
    
   
    if(arrCopyOfAllRecipeData[0][@"steps"]){
        
        if (arrCopyOfAllRecipeData[0][@"coverimage"]) {
            fileData =UIImageJPEGRepresentation(arrCopyOfAllRecipeData[0][@"coverimage"], 0.8).mutableCopy;
            
            
            
            
            
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
                if (uploadProgress.fractionCompleted==1) {
                    progress++;
                }
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
                                                      
                                                      NSString *aString =[NSString stringWithFormat:@"https://recipeapp-6bbd.restdb.io/media/%@",idOfImage];
                                                      [arrCopyOfAllRecipeData[0] setObject:aString forKey:@"coverimage"];
                                                      
                                                      
                                                      
                                                      //here
                                                  }
                                              }];
            
            [uploadTask resume];
            
        }
        
        for (int i=0; i<[arrCopyOfAllRecipeData[0][@"steps"] count]; i++) {
            
            fileData =UIImageJPEGRepresentation(arrCopyOfAllRecipeData[0][@"steps"][i][@"stepImage"], 0.8).mutableCopy;
            
            
            NSMutableURLRequest *request2 = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"https://recipeapp-6bbd.restdb.io/media" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                if(fileData){
                    [formData appendPartWithFileData:fileData
                                                name:@"poi_pic"
                                            fileName:@"poiPic.jpg"
                                            mimeType:@"application/octet-stream"];
                }
                
            } error:nil];
            
            [request2 setHTTPMethod:@"POST"];
            [request2 setAllHTTPHeaderFields:headers];
            
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            
            NSURLSessionUploadTask *uploadTask;
            uploadTask = [manager uploadTaskWithStreamedRequest:request2 progress:^(NSProgress * _Nonnull uploadProgress) {
                if (uploadProgress.fractionCompleted==1) {
                    progress++;
                }
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
                                                      
                                                      NSString *aString =[NSString stringWithFormat:@"https://recipeapp-6bbd.restdb.io/media/%@",idOfImage];
                                                      //                                              *coverImage=@"hello";
                                                      [arrCopyOfAllRecipeData[0][@"steps"][i] setObject:aString forKey:@"stepImage"];
//                                                      while(progress!=[arrCopyOfAllRecipeData[0][@"steps"] count]+2 && i==[arrCopyOfAllRecipeData[0][@"steps"] count]-1 ) {
//                                                          if (progress==[arrCopyOfAllRecipeData[0][@"steps"] count]+1) {
//                                                              NSLog(@"triggers");
//                                                              break;
//                                                          }
//                                                      }

                                                     
                                                  }
                                              }];
            
            [uploadTask resume];
        }
    }
 
}
#pragma mark - Collect Data

-(void)CollectData{
    
   
    [dictTempRecipe setObject:_txtFRecipeName.text forKey:@"name"];
    [dictTempRecipe setObject:_imgCoverImage.image forKey:@"coverimage"];
    [dictTempRecipe setObject:[NSString stringWithFormat:@"%ld",(long)_segmentVegNonVeg.selectedSegmentIndex]forKey:@"nonveg"];
    [dictTempRecipe setObject:_txtRecipeDiscription.text forKey:@"recipe_discription"];
    [dictTempRecipe setObject:_lblServes.text  forKey:@"serves"];
    [dictTempRecipe setObject:_lblTime.text  forKey:@"time"];
    [dictTempRecipe setObject:arrMutIngredient forKey:@"ingredient"];
    [dictTempRecipe setObject:arrMutSteps forKey:@"steps"];
    [dictTempRecipe setObject:_txtFCategory.text forKey:@"category"];
#warning getting userLocation is not set;
    [dictTempRecipe setObject:user forKey:@"author"];
    [dictTempRecipe setObject:@"sample" forKey:@"location"];
    [arrAllRecipeData addObject:dictTempRecipe];
    NSLog(@"all recipe data  \n %@",arrAllRecipeData);
     }

#pragma mark picker's methods
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerCategory count];
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return pickerCategory[row];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (IBAction)cancel:(id)sender {
    NSLog(@"check");
    [self.view endEditing:true];
    
}
- (IBAction)done:(UIButton *)sender {
    NSLog(@"selected element %ld",(long)[_uiPickerOutlet selectedRowInComponent:0]);
    _txtFCategory.text=pickerCategory[[_uiPickerOutlet selectedRowInComponent:0]];
    [_txtFCategory endEditing:true];
    
}

#pragma mark UIcontrols Init and data fetching



//-(NSString*)isBonveg{
//    if (_segmentVegNonVeg.selectedSegmentIndex==0) {
//        return @"Veg";
//    }
//    else if (_segmentVegNonVeg.selectedSegmentIndex==0) {
//        return @"NonVeg";
//    }
//    else{
//        NSLog(@"could not fetch segment data");
//        return @"undefined";
//    }
//}

#pragma mark set Slider Behaviour

- (IBAction)timeSliderValueChanged:(UISlider *)sender {
    NSLog(@"slider value = %f", sender.value);
    _lblTime.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:(int)roundf(sender.value)]];
}


- (IBAction)servesSliderValueChanged:(UISlider *)sender {
    NSLog(@"slider value = %f", sender.value);
    _lblServes.text=[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:(int)roundf(sender.value)]];
}

#pragma mark UIimagePikerViewDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"returened data %@",editingInfo);
    _imgCoverImage.image=image;
   
    
    
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
