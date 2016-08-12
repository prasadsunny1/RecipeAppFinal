//
//  IngredientResultVC.h
//  IosRecipeApp2
//
//  Created by indianic on 29/07/16.
//  Copyright © 2016 indianic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchByIngredientsViewController.h"
#import "RecipeDisplayVC.h"
#import "IngredientResultTableViewCell.h"
#import "IngResultNameCell.h"
#import "AppDelegate.h"
#import "UIKit+AFNetworking.h"

@interface IngredientResultVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *propingRecipeTBView;
@property (strong, nonatomic) IBOutlet UICollectionView *cvOfIngResultNames;

@property (strong,nonatomic) NSMutableArray *searchedResult;
@property (strong,nonatomic) NSMutableArray *finalResult;
@property (strong,nonatomic) NSMutableString *isTapped;



- (IBAction)onDrawer:(UIBarButtonItem *)sender;

- (IBAction)onBack:(UIBarButtonItem *)sender;



@end
