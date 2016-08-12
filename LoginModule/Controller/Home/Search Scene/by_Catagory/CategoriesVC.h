//
//  CategoriesVC.h
//  IosRecipeApp2
//
//  Created by indianic on 21/07/16.
//  Copyright © 2016 indianic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MKSlidingTableViewCell.h>
#import <MKActionTableViewCell.h>
#import "HomeVC.h"

@interface CategoriesVC : UIViewController<UITableViewDataSource, UITableViewDelegate>

- (IBAction)btnCategoriesAddNew:(UIButton *)sender;
- (IBAction)btnCategoriesFav:(UIButton *)sender;
- (IBAction)btnCategoriesPopular:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)onBack:(UIBarButtonItem *)sender;
- (IBAction)onDrawer:(UIBarButtonItem *)sender;
@property (strong, nonatomic) UIView *cellView;


@end
