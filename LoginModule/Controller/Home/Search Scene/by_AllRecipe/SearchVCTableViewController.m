//
//  SearchVCTableViewController.m
//  IosRecipeApp2
//
//  Created by indianic on 22/07/16.
//  Copyright © 2016 indianic. All rights reserved.
//

#import "SearchVCTableViewController.h"
#import "AppDelegate.h"

@interface SearchVCTableViewController ()

@end

@implementation SearchVCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // navigation bar methods
    self.navigationItem.title= _strNavTitle;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Cochin-Italic" size:21], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    
    
    // registering search bar delegate to this(self class)
    _searchBar.delegate = (id)self;
    
    
    //calling web services 
     [self getAllRecipe];   
    
}

-(void)getAllRecipe{
    
    if ([AppDelegate sharedInstance].isInternetAvailable)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *headers = @{ @"content-type": @"application/json",
                                   @"x-apikey": @"18961ebc916a47e54dae5dcb273d407508bbe"};
        
        NSString *url;
        if (_recipeType == 0)
        {
             url =[NSString stringWithFormat:@"https://recipeapp-6bbd.restdb.io/rest/recipes"];
        }
        else if (_recipeType == 1)
        {
          url =[NSString stringWithFormat:@"https://recipeapp-6bbd.restdb.io/rest/recipes?q={\"category\":\"%@\"}",_strCategoryName];
        }
        else if (_recipeType == 2)
        {
            url =[NSString stringWithFormat:@"https://recipeapp-6bbd.restdb.io/rest/recipes?q={\"location\":\"%@\"}",_strRegionName];
        }
        else if (_recipeType == 3)
        {
            url =[NSString stringWithFormat:@"https://recipeapp-6bbd.restdb.io/rest/recipes?q={\"time\":\"%@\"}",_strTime];
        }
        else if (_recipeType == 4)
        {
          url =[NSString stringWithFormat:@"https://recipeapp-6bbd.restdb.io/rest/recipes?q={\"userid\":\"%@\"}",_strRecipeFrom];
           
        }
        
        NSURL *myurl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        
        [request setHTTPMethod:@"GET"];
        [request setAllHTTPHeaderFields:headers];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            if (error) {
                NSLog(@"%@", error);
            } else {
                _arrDailyRecipes = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_allRecipeTable reloadData];
                });
                
            }
        }];
        [dataTask resume];
        
    }
    else
    {
        
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [super viewDidUnload];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //checking if person is on view controller or on search bar
    
    NSInteger rowCount;
    if(self.isFiltered)
        rowCount = _filteredDailyRecipes.count;
    else
        rowCount = _arrDailyRecipes.count;
    
    return rowCount;
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //instantiating custom cell of table view
    
    static NSString *CellIdentifier = @"SearchAllRecipesTableViewCell";
    
    SearchAllRecipesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[SearchAllRecipesTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    //displaying data in table according to state ie has searched or not
    
    NSMutableDictionary *result;
    if(_isFiltered)
        result = [_filteredDailyRecipes objectAtIndex:indexPath.row];
    else
       result = [_arrDailyRecipes objectAtIndex:indexPath.row];
   

    
    // Configure the cell...
    
    cell.backgroundColor = [UIColor whiteColor];
    
    //image view of cell
    [cell.AllRecipeDisplayImageProp setImageWithURL:[NSURL URLWithString:[result valueForKey:@"coverimage"]]placeholderImage:[UIImage imageNamed:@"placeholder"]];

    //image view for recipe type
    if ([[result valueForKey:@"nonveg"] isEqual: @"0"])
    {
        cell.imgAllRecipeType.image = [UIImage imageNamed:@"veg icon"];
    }
    else
    {
        cell.imgAllRecipeType.image = [UIImage imageNamed:@"nonveg_icon"];
    }
    
    // recipe name label
    cell.lblAllRecipeName.text = [result valueForKey: @"name"];
    cell.lblAllRecipeName.userInteractionEnabled = false;
    
    //recipe cooking time label
    cell.lblAllRecipeCookingTime.text = [result valueForKey:@"time"];
    cell.lblAllRecipeCookingTime.userInteractionEnabled = false;
    
    //recipe serves label
    cell.lblAllRecipeServes.text = [result valueForKey:@"serves"];
    cell.lblAllRecipeServes.userInteractionEnabled = false;

    
    return cell;
}


#pragma mark - Search Bar Delegate

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
   
    
   // searching ie filtering searched content from table methods
    
    BOOL ans= false;
    
    if(text.length == 0)
    {
        _isFiltered = FALSE;
    }
    else
    {
        _isFiltered = true;
        _filteredDailyRecipes = [[NSMutableArray alloc] init];
        
        
        
       
        
        for (NSMutableDictionary *result in _arrDailyRecipes)
        {
            NSMutableString* name =  [result  valueForKey: @"name"];
            
            NSRange nameRange = [name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [name.description rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
            {
                ans = true;
                [_filteredDailyRecipes addObject:result];
            }
  
        }
        
    }
    
    if (ans == false) {
        
            [_filteredDailyRecipes addObject:[_arrDailyRecipes firstObject]];
    }
    
    [self.tableView reloadData];
}


#pragma mark - Table view clicked/ delegate methods

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailsForIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailsForIndexPath:indexPath];
}

-(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
{
    
    RecipeDisplayVC  * recipeDisplayVc = [self.storyboard instantiateViewControllerWithIdentifier:@"RecipeDisplayVC"];

   
    NSMutableDictionary *result;
    
    if(_isFiltered)
    {
        result = [_filteredDailyRecipes objectAtIndex:indexPath.row];
    }
    else
    {
        result = [_arrDailyRecipes objectAtIndex:indexPath.row];
    }
    
   recipeDisplayVc.result = result;
    
    if (_recipeType == 0)
    {
        recipeDisplayVc.strNavTitle = @"Recipes";
    }
    else if (_recipeType == 1)
    {
        recipeDisplayVc.strNavTitle = @"Category";
    }
    else if (_recipeType == 2)
    {
        recipeDisplayVc.strNavTitle = @"Region";
    }
    else if (_recipeType == 3)
    {
        recipeDisplayVc.strNavTitle = @"Time";
    }
    else if (_recipeType == 4)
    {
        recipeDisplayVc.strNavTitle = @"My Recipes";
    }
    
    [self.navigationController pushViewController:recipeDisplayVc animated:true];
}


#pragma mark - back bar button and drawer bar button tapped action
- (IBAction)btnBarButtonBack:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDrawer:(UIBarButtonItem *)sender {
}


@end
