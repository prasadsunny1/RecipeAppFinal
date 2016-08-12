//
//  RegionVC.h
//  LoginModule
//
//  Created by indianic on 03/08/16.
//  Copyright © 2016 creativeIOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
#import "RegionCell.h"
#import "SearchVCTableViewController.h"

@interface RegionVC : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *propRegionCV;
- (IBAction)onBack:(UIBarButtonItem *)sender;
- (IBAction)onDrawer:(UIBarButtonItem *)sender;

@property (strong, nonatomic) NSMutableArray *arrRegionCollection;

@end
