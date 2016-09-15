//
//  RefinedSearch.h
//  Recipe
//
//  Created by indianic on 11/09/16.
//  Copyright © 2016 creativeIOS. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "SearchByIngredientsViewController.h"

@interface RefinedSearch : UIViewController <UITableViewDelegate,UITableViewDataSource>


@property (strong,nonatomic) NSMutableArray *searchedResult;
@property (strong,nonatomic) NSMutableArray *finalResult;
//@property (strong, nonatomic) NSMutableDictionary *result;

@end
