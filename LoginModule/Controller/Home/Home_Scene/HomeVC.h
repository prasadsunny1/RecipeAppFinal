//
//  HomeVC.h
//  IosRecipeApp2
//
//  Created by indianic on 21/07/16.
//  Copyright © 2016 indianic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDailyRecipeCVCell.h"
#import "RecipeDisplayVC.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "UIKit+AFNetworking.h"

@interface HomeVC : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet __block UICollectionView *homeTopRatedRecipeCV;
@property (strong, nonatomic) __block NSMutableArray* arrDailyRecipes;
- (IBAction)onDrawer:(UIBarButtonItem *)sender;
- (IBAction)btnOnBack:(UIBarButtonItem *)sender;
@property (strong, nonatomic) NSString *isBackOn;
@end
