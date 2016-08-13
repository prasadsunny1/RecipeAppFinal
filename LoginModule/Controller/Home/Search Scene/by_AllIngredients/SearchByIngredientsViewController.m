//
//  SearchByIngredientsViewController.m
//  IosRecipeApp2
//
//  Created by indianic on 24/07/16.
//  Copyright © 2016 indianic. All rights reserved.
//

#import "SearchByIngredientsViewController.h"

@interface SearchByIngredientsViewController ()
{
    int b;

}

@end

@implementation SearchByIngredientsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //declaring sets
    _selectedNames=[NSMutableSet new];
    _searchedResult = [NSMutableSet new];
   
   
    // navigation bar methods
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Cochin-Italic" size:21], NSForegroundColorAttributeName: [UIColor whiteColor]};

    
    // registering collection view delegate
    _propIngredientSearchBar.delegate = (id)self;
    
   
    
    // defining variables of ingredient name, image and selected stated with help of method declared in recipe.m
    _arrCollection = [[NSMutableArray alloc]initWithObjects:[[Recipe alloc]initwithIngredientName:@"Broccoli" andIngredientImage: @"Broccoli" andCheckSelected:@"no"],[[Recipe alloc]initwithIngredientName:@"Cabbage" andIngredientImage: @"Cabbage" andCheckSelected:@"no"],[[Recipe alloc]initwithIngredientName:@"Carrot" andIngredientImage: @"Carrot" andCheckSelected:@"no"],[[Recipe alloc]initwithIngredientName:@"Cauliflower" andIngredientImage: @"Cauliflower" andCheckSelected:@"no"],[[Recipe alloc]initwithIngredientName:@"Corn" andIngredientImage: @"Corn" andCheckSelected:@"no"],[[Recipe alloc]initwithIngredientName:@"Cucumber" andIngredientImage: @"Cucumber" andCheckSelected:@"no"],[[Recipe alloc]initwithIngredientName:@"Eggplant" andIngredientImage: @"Eggplant" andCheckSelected:@"no"],[[Recipe alloc]initwithIngredientName:@"GreenBean" andIngredientImage: @"GreenBean" andCheckSelected:@"no"],[[Recipe alloc]initwithIngredientName:@"Mushroom" andIngredientImage: @"Mushroom" andCheckSelected:@"no"],[[Recipe alloc]initwithIngredientName:@"Onion" andIngredientImage: @"Onion" andCheckSelected:@"no"],[[Recipe alloc]initwithIngredientName:@"Potato" andIngredientImage: @"Potato" andCheckSelected:@"no"],[[Recipe alloc]initwithIngredientName:@"Tomato" andIngredientImage: @"Tomato" andCheckSelected:@"no"], nil];
    
    
   //setting collection view hidden on load
    _propForImgredientsImages.hidden = YES;

     [self getAllRecipe];
    
}

- (void)viewDidUnload
{
    [self setPropIngredientSearchBar:nil];
    [super viewDidUnload];
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
            } else
            {
                _arrDailyRecipes = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
                
            }
        }];
        [dataTask resume];
        
    }
    else
    {
        [[AppDelegate sharedInstance]showAlertInController:self WithMessage:@"Inter Is Not Available \n Please Try Again"];
        
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
   
    for (int i = 0; i<_arrCollection.count; i++)
    {
        Recipe *recipe;
        recipe = _arrCollection[i];
        recipe.isSelected = @"no";
    }
       [_propForImgredientsImages reloadData];
    [self setPropIngredientSearchBar:nil];

    if (_isTapped == YES) {
         _propForImgredientsImages.hidden = NO;
    }
    else
    {
        _propForImgredientsImages.hidden = YES;
        
    }


}



#pragma mark- BMCheckBox Method

-(void)didTapCheckBox:(BEMCheckBox *)checkBox{
 
    
    b++;
    if(b%2!=0)
    {
        _isTapped = YES;
        _propForImgredientsImages.hidden = NO;
    }
    else
    {
        _isTapped = NO;
        _propForImgredientsImages.hidden = YES;
    }

    
}

#pragma mark - collection view datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
     
   
    if(self.isFiltered)
        rowCount = _arrfilterCollection.count;
    else
        rowCount = _arrCollection.count;
    
    return rowCount;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchIngredientsImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchIngredientsImageCollectionViewCell" forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 15.0f;
    cell.layer.masksToBounds = YES;
    
    Recipe *recipe;
    if(_isFiltered)
        recipe = [_arrfilterCollection objectAtIndex:indexPath.row];
    else
        recipe = [_arrCollection objectAtIndex:indexPath.row];
    
    cell.imgSearchByIngredients.image = [UIImage imageNamed:recipe.ingredientsImages];
    cell.lblSearchByIngredientName.text = recipe.ingredientsNames;
 

    

        if ([recipe.isSelected  isEqual: @"yes"])
       {
            cell.alpha=0.5f;
           
           [_selectedNames addObject: recipe.ingredientsNames];

       }
        else if([recipe.isSelected  isEqual: @"no"])
        {
            
            cell.alpha=1.0f;

                [_selectedNames removeObject:recipe.ingredientsNames];
            
            
            [_searchedResult removeObject:recipe.ingredientsNames];
         }
    
    
       for (NSMutableString *imgNames in _selectedNames)
       {
           [_searchedResult addObject:imgNames];
       }
  

    return cell;
}


#pragma mark - search filtering method

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    
    //searching ie filtering searched content from table methods
   _searchWords = (NSMutableArray *)[text componentsSeparatedByString:@","];
   
    NSString *searchString;
    
    for (int i =0;i<_searchWords.count;i++){
        
        searchString = _searchWords[i];
    }

    if(text.length == 0)
    {
        _isFiltered = FALSE;
    }
    else
    {
        _isFiltered = true;
        _arrfilterCollection = [[NSMutableArray alloc] init];
        
        for (Recipe *recipe in _arrCollection)
        {
            NSRange nameRange = [recipe.ingredientsNames rangeOfString:searchString options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [recipe.description rangeOfString:searchString options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
            {
                [_arrfilterCollection addObject:recipe];
            }
        }
    }
    
    [self.propForImgredientsImages reloadData];
    
}



#pragma mark- collection view delegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
     Recipe *recipe;
    
    if(self.isFiltered)
        recipe = [_arrfilterCollection objectAtIndex:indexPath.row];
    else
        recipe = [_arrCollection objectAtIndex:indexPath.row];


    if ([recipe.isSelected  isEqual: @"yes"])
    {
        recipe.isSelected = @"no";
    }
    else if([recipe.isSelected  isEqual: @"no"])
    {
        recipe.isSelected = @"yes";
    }


    [_propForImgredientsImages reloadData];

  
}

#pragma mark- done button method

- (IBAction)btnDone:(UIButton *)sender {
    
   
      _a = [NSSet new];
    
    NSMutableArray *searchResult = [NSMutableArray array];

    for (NSMutableString *searchString in _searchedResult) {
        [searchResult  addObject:[searchString lowercaseString]];
    }

    for (NSMutableString *searchString in _searchWords) {
        [searchResult  addObject:[searchString lowercaseString]];
    }
    
  

     NSMutableArray *f = [NSMutableArray array];
    for ( NSMutableDictionary *data in _arrDailyRecipes) {
        
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result addEntriesFromDictionary:data];
    
        for (NSMutableDictionary *ingredient in [result valueForKey:@"ingredient"]) {
            
            NSMutableDictionary *ingname  = [NSMutableDictionary dictionary];
            [ingname setValue:ingredient forKey:@"recipeing"];
            
            
            for (NSMutableString *filter in searchResult)
            {

                if ([[filter lowercaseString] isEqualToString:[result[@"ingredient"][ingname[@"recipeing"]]lowercaseString]])
                {
                   
                    [f addObject:[filter lowercaseString]];
                   _a =  [_a setByAddingObject:data];
                }
            }
        }
    }
    
    
    NSMutableArray *arrOfIngResult = [NSMutableArray array];
    for (NSMutableDictionary *temp in _a) {
        [arrOfIngResult addObject:temp];
    }
    
    NSMutableSet *setOfF = [NSMutableSet set];
    for (NSMutableString *tempf in f) {
        [setOfF addObject:tempf];
    }
  
    NSMutableArray *arrF = [NSMutableArray array];
    for (NSMutableString *ofF in setOfF) {
        [arrF addObject:ofF];
    }
    
   IngredientResultVC *objIngVc = [self.storyboard instantiateViewControllerWithIdentifier:@"IngredientResultVC"];
    objIngVc.searchedResult = arrOfIngResult;
    objIngVc.finalResult = arrF;
    [self.navigationController pushViewController:objIngVc animated:true];
}


#pragma mark - bar buttons method

- (IBAction)btnBack:(UIBarButtonItem *)sender {

    [self.navigationController popViewControllerAnimated:YES];

}


- (IBAction)onDrawer:(UIBarButtonItem *)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}
@end
