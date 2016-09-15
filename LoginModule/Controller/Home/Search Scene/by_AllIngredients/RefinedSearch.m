//
//  RefinedSearch.m
//  Recipe
//
//  Created by indianic on 11/09/16.
//  Copyright © 2016 creativeIOS. All rights reserved.
//

#import "RefinedSearch.h"

@interface RefinedSearch ()

@end

@implementation RefinedSearch

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Searched Result %@",_searchedResult);
    
        // Do any additional setup after loading the view.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //instantiating custom cell of table view
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSMutableDictionary *result = [_searchedResult objectAtIndex:indexPath.row];
    
    NSLog(@"result %@",result);

    
    // Configure the cell...
    
    cell.backgroundColor = [UIColor whiteColor];
    
    NSMutableDictionary *ingname  = [NSMutableDictionary dictionary];
    NSMutableArray *ing = [NSMutableArray array];
    
    for (NSMutableDictionary *ingredient in [result valueForKey:@"ingredient"])
    {
        [ingname setValue:ingredient forKey:@"recipeing"];
        
        
        [ing addObject:result[@"ingredient"][ingname[@"recipeing"]]];
        
    }
    NSLog(@"ing %@",ing);
    
    for (int i =0; i<ing.count; i++) {
        cell.textLabel.text = ing[i];
    }
    
//    cell.textLabel.text = [_searchedResult objectAtIndex:indexPath.row][@"ingredient"];
    
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
