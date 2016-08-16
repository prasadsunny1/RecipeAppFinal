//
//  HomeVC.m
//  IosRecipeApp2
//
//  Created by indianic on 21/07/16.
//  Copyright © 2016 indianic. All rights reserved.
//

#import "HomeVC.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "UIKit+AFNetworking.h"

@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //navigation bar methods
   
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Cochin-Italic" size:21], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    
    //calling web services
    [self getAllRecipe];
    
    //checking if back is on
    if ([_isBackOn isEqualToString:@"Yes"])
    {
        self.navigationItem.hidesBackButton = YES;
        
    }
    else
    {
        self.navigationItem.leftBarButtonItems = nil;
        
    }
    
 

}

-(void)getAllRecipe{
    
    if ([AppDelegate sharedInstance].isInternetAvailable)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *headers = @{ @"content-type": @"application/json",
                                   @"x-apikey": @"18961ebc916a47e54dae5dcb273d407508bbe"};
        NSString *url =[NSString stringWithFormat:@"https://recipeapp-6bbd.restdb.io/rest/recipes"];
        
        NSURL *myurl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        
        [request setHTTPMethod:@"GET"];
        [request setAllHTTPHeaderFields:headers];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            if (error)
            {
               [[AppDelegate sharedInstance]showAlertInController:self WithMessage:@"Request Has Been Timed Out. \n Please Try Again"];
            } else {
                _arrDailyRecipes = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                          [_homeTopRatedRecipeCV reloadData];

                });
             
            }
        }];
        [dataTask resume];

    }
    else
    {
        [[AppDelegate sharedInstance]showAlertInController:self WithMessage:@"Internet Is Not Available. \n Please Try Again"];
        
    }
}

//
#pragma mark - collection view datasource 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _arrDailyRecipes.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeDailyRecipeCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeDailyRecipeCVCell" forIndexPath:indexPath];
    
    
    //defining properties of recipe name label
    [cell.topRatedRecipeHomeImgs setImageWithURL:[NSURL URLWithString:_arrDailyRecipes[indexPath.row][@"coverimage"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
  
    
    cell.homeTopRatedRecipeName.text = [_arrDailyRecipes objectAtIndex:indexPath.row][@"name"];
    cell.homeTopRatedRecipeName.userInteractionEnabled = false;
    
    
    
    //defining properties of recipe description label
    cell.homeTopRatedRecipeDesc.text = _arrDailyRecipes[indexPath.row][@"recipe_discription"];
    cell.homeTopRatedRecipeDesc.lineBreakMode = YES;
    cell.homeTopRatedRecipeDesc.userInteractionEnabled = false;
    
    
    
    //defining properties of recipe cooking time label
    cell.homeCookingTime.text = [_arrDailyRecipes objectAtIndex:indexPath.row][@"time"];
    cell.homeCookingTime.userInteractionEnabled = false;
    
    
    
    //defining properties of recipe serve counts label
    cell.homeServes.text = [_arrDailyRecipes objectAtIndex:indexPath.row][@"serves"];
    cell.homeServes.userInteractionEnabled = false;
    
    return cell;
}

#pragma mark- collection view delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    RecipeDisplayVC  * objVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RecipeDisplayVC"];
    
    NSMutableDictionary *result = [_arrDailyRecipes objectAtIndex:indexPath.row];
   
    
    objVC.result = result;
    objVC.strNavTitle = @"Home";
    [self.navigationController pushViewController:objVC animated:true];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onDrawer:(UIBarButtonItem *)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (IBAction)btnOnBack:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
