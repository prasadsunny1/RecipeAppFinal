//
//  RecipeDisplayVC.h
//  IosRecipeApp2
//
//  Created by indianic on 22/07/16.
//  Copyright © 2016 indianic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeDisplayIngredientsCVCell.h"
#import "RecipeDisplayStepsTableViewCell.h"
#import "SearchVCTableViewController.h"
#import "FavouritesVC.h"
#import "CCDropDownMenus.h"
#import "ManaDropDownMenu.h"
#import "IngredientResultVC.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "MBProgressHUD.h"
#import "UIKit+AFNetworking.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
 


@interface RecipeDisplayVC : UIViewController <CCDropDownMenuDelegate>
{
    MBProgressHUD *progress;

}

@property (strong, nonatomic) IBOutlet UIImageView *RecipeDisplayCoverPhoto;
@property (strong, nonatomic) IBOutlet UIView *recipeDisplayViewForItsProperties;
@property (strong, nonatomic) IBOutlet UILabel *lblRecipeDisplayLocationName;
@property (strong, nonatomic) IBOutlet UILabel *lblRecipeDisplayCookingTime;
@property (strong, nonatomic) IBOutlet UILabel *lblRecipeDisplayServes;
@property (strong, nonatomic) IBOutlet UITableView *RecipeDisplayStepsTBVProp;
@property (strong, nonatomic) IBOutlet UILabel *lblRecipeDisplayName;
@property (strong, nonatomic) IBOutlet UILabel *lblRecipeDisplayAuthorName;
- (IBAction)btnFavourites:(UIButton *)sender;
- (IBAction)btnShare:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *favouriteProp;
@property (strong, nonatomic) IBOutlet UIButton *shareProp;
@property (strong, nonatomic) IBOutlet UILabel *lblRecipeDisplayCategory;
- (IBAction)onDrawer:(UIBarButtonItem *)sender;

@property (nonatomic, strong) ManaDropDownMenu *menu1;

@property (strong, nonatomic) NSMutableDictionary *result;
@property (strong, nonatomic) NSMutableDictionary *dicFromIngVC;
@property (nonatomic, assign) bool isOn;


@property (nonatomic, copy) NSString *contentDescription;
@property (nonatomic, copy) NSString *contentTitle;

@end
