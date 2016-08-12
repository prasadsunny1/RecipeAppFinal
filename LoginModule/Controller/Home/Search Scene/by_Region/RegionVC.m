//
//  RegionVC.m
//  LoginModule
//
//  Created by indianic on 03/08/16.
//  Copyright © 2016 creativeIOS. All rights reserved.
//

#import "RegionVC.h"

@interface RegionVC ()

@end

@implementation RegionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //navigation bar methods
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Cochin-Italic" size:21], NSForegroundColorAttributeName: [UIColor whiteColor]};

    
    //declaring collection view data with help of method declared in recipe.m
    _arrRegionCollection = [[NSMutableArray alloc]initWithObjects:[[Recipe alloc]initwithRegionName:@"GUJARAT" andRegionImage: @"gujarat" andRegionDesc:@"Gujarat know for its Gujarati \n Cuisine-a typical Gujarati thali consists \n of rotli, dal or kadhi, rice, \n and shaak/sabzi. The thali will \n also include preparations made \n \n from pulses or whole beans \n and a sweet like mohanthal, \n jalebi, doodh pak etc"],[[Recipe alloc]initwithRegionName:@"MAHARASTRA" andRegionImage: @"maharastra" andRegionDesc:@"Vada Pav is noted as the most \n popular street food in Mumbai- capital \n  og Maharastra.Other \n  noted street foods include Panipuri, \n Bhelpuri, Sevpuri,Ragda-pattice, \n Pav Bhaji, Chinese bhel, \n idlis and Dosas,kebabs and fish are found on Mumbai streets"],[[Recipe alloc]initwithRegionName:@"RAJASTHAN" andRegionImage: @"rajasthan" andRegionDesc:@"Rajasthani cusine is known for \n its snacks like Bikaneri Bhujia,Mirchi Bada \n and Pyaaj Kachori. Other famous dishes \n include Bajre ki roti and Lashun \n ki chutney, Mawa Kachori \n from jodhpur, Alwar ka mawa, Malpauas  \n from pushkar and Rassgollas from Bikaner, \n paniya and gheriya."],[[Recipe alloc]initwithRegionName:@"PUNJAB" andRegionImage: @"punjab" andRegionDesc:@"This cuisine has a rich tradition  \n of many distinct and local ways of cooking. One is a special  \n form of tandoori cooking style.Its dishes  \n are'makke ki roti','sarso da shak',  \n Chole, Paratha/Aloo Paratha, Halwa poori, \n Bhatoora, Falooda, Makhni doodh,Amritsari  \n Lassi,Khoa, Paya, Aloo Paratha,kabab etc."],[[Recipe alloc]initwithRegionName:@"HARYANA" andRegionImage: @"haryana" andRegionDesc:@" Haryanvi cusine is know for its \n rottis and dairy products.  \n Wheat rotis are common and so are baajre \n ki roti. People make home made butter  \n and gift to people.Other famous items \n are Kachri Ki Sabzi,Singri Ki Sabzi, \n Hara Dhania Cholia,Methi Gajjar, \n Kadhi Pakora,Mixed Dal"], nil];

}

#pragma mark - collection view datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _arrRegionCollection.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RegionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RegionCell" forIndexPath:indexPath];
    
    Recipe *recipe;
    recipe = [_arrRegionCollection objectAtIndex:indexPath.row];
    
    cell.layer.cornerRadius = 15.0f;
    cell.layer.masksToBounds = YES;
    
    cell.imgRegionCover.image = [UIImage imageNamed:recipe.regionImage];
    cell.imgRegionCover.layer.cornerRadius = 35.0f;
    cell.imgRegionCover.layer.masksToBounds = YES;
    
    cell.lblRegionName.text = recipe.regionName;
    cell.lblRegionDesc.text = recipe.regionDesc;
    
    
    return cell;
}

#pragma mark - collection view delegate methods
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    Recipe *recipe;
    recipe = [_arrRegionCollection objectAtIndex:indexPath.row];
    
    SearchVCTableViewController *objVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchVCTableViewController"];
    objVC.recipeType = 2;
    objVC.strRegionName = recipe.regionName.lowercaseString;
    NSLog(@"name is %@",recipe.regionName.lowercaseString);
    objVC.strNavTitle = @"Region";
    [self.navigationController pushViewController:objVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- bar button on tapped methods

- (IBAction)onBack:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)onDrawer:(UIBarButtonItem *)sender {
}
@end
