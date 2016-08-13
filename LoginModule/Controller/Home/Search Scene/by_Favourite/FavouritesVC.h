//
//  FavouritesVC.h
//  IosRecipeApp2
//
//  Created by indianic on 21/07/16.
//  Copyright © 2016 indianic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
#import "FavsCell.h"
#import "SearchVCTableViewController.h"

@interface FavouritesVC : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewFav;
- (IBAction)onDrawer:(UIBarButtonItem *)sender;

@property (strong,nonatomic) NSMutableArray* cvData;

@end
