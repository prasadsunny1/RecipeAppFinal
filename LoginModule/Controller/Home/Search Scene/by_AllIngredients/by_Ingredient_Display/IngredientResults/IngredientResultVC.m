//
//  IngredientResultVC.m
//  IosRecipeApp2
//
//  Created by indianic on 29/07/16.
//  Copyright © 2016 indianic. All rights reserved.
//

#import "IngredientResultVC.h"

@interface IngredientResultVC ()

@end

@implementation IngredientResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //navigation item tittle color
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Cochin-Italic" size:21], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
   
}


#pragma mark - collection view datasource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _finalResult.count;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    IngResultNameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IngResultNameCell" forIndexPath:indexPath];
    
    cell.lblIngResultName.text = [_finalResult objectAtIndex:indexPath.row];
    cell.lblIngResultName.userInteractionEnabled = false;

    
    return cell;
 
   
}


#pragma mark - collection view delegate method

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSMutableString *filter = [_finalResult objectAtIndex:indexPath.row];


    NSMutableArray *arrforCount = [NSMutableArray array];
    for (int i = 0; i<_searchedResult.count; i++) {
        [arrforCount addObject:_searchedResult[i]];
    }
   
    
    for (int i =0; i<arrforCount.count; i++)
    {
     
      for (NSDictionary *check in arrforCount[i][@"ingredient"])
     {
         
          if ([filter isEqualToString:[[arrforCount[i][@"ingredient"] valueForKey:(NSMutableString *)check]lowercaseString]])
            
              
         {
             [_searchedResult removeObject:arrforCount[i]];
            
                        
         }
  
       }
    }
    [_propingRecipeTBView reloadData];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchedResult.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //instantiating custom cell of table view

    static NSString *CellIdentifier = @"IngredientResultTableViewCell";
    
    IngredientResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[IngredientResultTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

    // Configure the cell...
    
    cell.backgroundColor = [UIColor whiteColor];
    
    //image view of cell
    [cell.imgCover setImageWithURL:[NSURL URLWithString:[_searchedResult objectAtIndex:indexPath.row][@"coverimage"]] placeholderImage:nil];
   
    
    // recipe name label
    cell.ingresultRecipeName.text = [_searchedResult objectAtIndex:indexPath.row][@"name"];
   cell.ingresultRecipeName.userInteractionEnabled = false;
    
    //recipe cooking time label
    cell.ingresultRecipeCookTime.text = [_searchedResult objectAtIndex:indexPath.row][@"time"];
    cell.ingresultRecipeCookTime.userInteractionEnabled = false;
    
    //recipe serves label
    cell.ingrrecipeResultServes.text = [_searchedResult objectAtIndex:indexPath.row][@"serves"];
    cell.ingrrecipeResultServes.userInteractionEnabled = false;
    
    
    //image view for recipe type
    if ([[_searchedResult objectAtIndex:indexPath.row][@"nonveg"] isEqual: @"0"])
    {
        cell.imgingresultRecipeType.image = [UIImage imageNamed:@"veg icon"];
    }
    else
    {
        cell.imgingresultRecipeType.image = [UIImage imageNamed:@"nonveg_icon"];
    }

    
    return cell;
}

#pragma mark - tableview delegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *result = [_searchedResult objectAtIndex:indexPath.row];
    
    RecipeDisplayVC *objVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RecipeDisplayVC"];
    
    objVC.result = result;
    [self.navigationController pushViewController:objVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - bar button methods
- (IBAction)onBack:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
   
}

- (IBAction)onDrawer:(UIBarButtonItem *)sender {
}
@end
