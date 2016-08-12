//
//  SearchVCTableViewController.h
//  IosRecipeApp2
//
//  Created by indianic on 22/07/16.
//  Copyright © 2016 indianic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchAllRecipesTableViewCell.h"
#import "RecipeDisplayVC.h"
#import "SearchVC.h"
#import "IngredientResultVC.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "UIKit+AFNetworking.h"

typedef enum RecipeType : NSUInteger {
    kAllRecipe,
    kByCategory,
    kByRegion,
    kMYTime,
    kMyRecipes
} RecipeType;

@interface SearchVCTableViewController : UITableViewController

- (IBAction)btnBarButtonBack:(UIBarButtonItem *)sender;
- (IBAction)onDrawer:(UIBarButtonItem *)sender;


@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray* arrDailyRecipes;
@property (strong, nonatomic) NSMutableArray* filteredDailyRecipes;
@property (nonatomic, assign) bool isFiltered;
@property (strong, nonatomic) IBOutlet UITableView *allRecipeTable;

@property (nonatomic,assign) RecipeType recipeType;
@property (nonatomic,strong) NSString *strCategoryName;
@property (nonatomic,strong) NSString *strRegionName;
@property (nonatomic,strong) NSString *strRecipeFrom;
@property (nonatomic,strong) NSString *strTime;
@property (nonatomic,strong) NSString *strNavTitle;



@end
