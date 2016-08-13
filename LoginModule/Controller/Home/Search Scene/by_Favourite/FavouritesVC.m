//
//  FavouritesVC.m
//  IosRecipeApp2
//
//  Created by indianic on 21/07/16.
//  Copyright © 2016 indianic. All rights reserved.
//

#import "FavouritesVC.h"

@interface FavouritesVC ()

@end

@implementation FavouritesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //navigation bar methods
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Cochin-Italic" size:21], NSForegroundColorAttributeName: [UIColor whiteColor]};

    // defining collection view data with help of method declared in recipe.m
    
    _cvData = [NSMutableArray arrayWithObjects:[[Recipe alloc]initwithtimeImage:@"alarm3" andTimeMins:@"20 Mins" andTimeColor:[UIColor colorWithRed:0.5647 green:0.9333 blue:0.5647 alpha:1.0f]],[[Recipe alloc]initwithtimeImage:@"alarm7" andTimeMins:@"30 Mins" andTimeColor: [UIColor colorWithRed:1.0 green: 1.0 blue:0.0 alpha:1.0f]],[[Recipe alloc]initwithtimeImage:@"alarm8" andTimeMins:@"45 Mins" andTimeColor: [UIColor colorWithRed:0.6784 green: 0.8471 blue:0.9020 alpha:1.0f]],[[Recipe alloc]initwithtimeImage:@"alarm6" andTimeMins:@"60 Mins" andTimeColor: [UIColor colorWithRed:1.0 green: 0.4118 blue:0.7059 alpha:1.0f]],[[Recipe alloc]initwithtimeImage:@"alarm4" andTimeMins:@"90 Mins" andTimeColor: [UIColor colorWithRed:1.0 green: 0.2706 blue:0.0 alpha:1.0f]], nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collection view datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _cvData.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FavsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FavsCell" forIndexPath:indexPath];
    
    Recipe *recipe;
    recipe = [_cvData objectAtIndex:indexPath.row];
    
    cell.layer.cornerRadius = 15.0f;
    cell.layer.masksToBounds = YES;
    
    cell.imgOfFavs.image = [UIImage imageNamed:recipe.timeImage];
    cell.imgOfFavs.layer.cornerRadius = 25.0f;
    cell.imgOfFavs.layer.masksToBounds = YES;
    cell.imgOfFavs.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    cell.lblFavName.text = recipe.timeMins;
    cell.lblFavName.textColor = recipe.timeColor ;
    cell.lblIhavegot.textColor = recipe.timeColor;
    
    
    return cell;
}

#pragma mark - collection view delegate methods
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    Recipe *recipe;
    recipe = [_cvData objectAtIndex:indexPath.row];
    
    SearchVCTableViewController *objVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchVCTableViewController"];
    objVC.recipeType = 3;
    objVC.strTime = recipe.timeMins.lowercaseString;
    NSLog(@"time %@",recipe.timeMins.lowercaseString);
    objVC.strNavTitle = @"Time";
    [self.navigationController pushViewController:objVC animated:YES];
    
}

#pragma mark - bar button on tapped methods
- (IBAction)onDrawer:(UIBarButtonItem *)sender
{
  [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];  
    
}


@end
