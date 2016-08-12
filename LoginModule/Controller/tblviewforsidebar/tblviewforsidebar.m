//
//  tblviewforsidebar.m
//  LoginModule
//
//  Created by indianic on 01/08/16.
//  Copyright © 2016 creativeIOS. All rights reserved.
//

#import "tblviewforsidebar.h"
#import "MMDrawerController.h"
#import "UploadYourRecipeViewController.h"
#import "myprofilevc.h"
#import "FavouritesVC.h"
#import "AppDelegate.h"


@interface tblviewforsidebar (){
    NSString *profilePic;
}

@end

@implementation tblviewforsidebar

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    _imgUserProfileSidebar.layer.cornerRadius=42.0;
    
    profilePic =[AppDelegate sharedInstance].profilepic;

    _lblUserNameSidebar.text=[AppDelegate sharedInstance].userName;
    
     _imgUserProfileSidebar.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profilePic]]];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [_viewUserProfile addGestureRecognizer:singleFingerTap];
    
    
    _tableViewSidebar.tableFooterView=[UIView new];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView DataSourse Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *strCellID = @"cellmenu";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strCellID];
//    cell.backgroundColor = [UIColor colorWithRed:159.0/255.0 green:7.0/255.0 blue:18.0/255.0 alpha:1.2f];
    cell.textLabel.textColor = [UIColor whiteColor];
   // tableView.backgroundColor = [UIColor colorWithRed:170.0/255.0 green:6.0/255.0 blue:5.0/255.0 alpha:2.0f];
   /* if (indexPath.section == 0)
    {
        cell.textLabel.text = @"My Profile";
        cell.imageView.image = [UIImage imageNamed:@"homeimg"];
        
        //                UIImageView *dot =[[UIImageView alloc] initWithFrame:CGRectMake(50,50,20,20)];
        //        dot.image=[UIImage imageNamed:@"homeimg"];
        //        [self.view addSubview:dot];
    }*/
    if (indexPath.section == 0)
    {
        cell.textLabel.text = @"Home";
        cell.imageView.image = [UIImage imageNamed:@"homeimg"];
        
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = @"Upload Your Recipe";
        cell.imageView.image = [UIImage imageNamed:@"uploadimg"];
        
    }
    else if(indexPath.section==2)
    {
        cell.textLabel.text = @"Favourites";
        cell.imageView.image = [UIImage imageNamed:@"favimg"];
    }
    

    else if(indexPath.section==3)
    {
        cell.textLabel.text = @"Sign Out";
        cell.imageView.image = [UIImage imageNamed:@"signoutimg"];
    }
    else if(indexPath.section==4)
    {
        
        cell.textLabel.text = @"About Us";
        cell.imageView.image = [UIImage imageNamed:@"aboutusimg"];
    }
    else
    {
        
        cell.textLabel.text = @"Ask Question";
        cell.imageView.image = [UIImage imageNamed:@"askqueimg"];
        
        
    }
    
    return cell;
}


#pragma mark - TableView Delegate Methods

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    
    return aView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 2;
}

//
//- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    switch (indexPath.row){
//        case 0:
//            if(indexPath.section==0)
//                return 123.0;
//        default:
//            return 40.0;
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Table Clicked at Index : %ld",(long)indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0) {
        
         myprofilevc *objmyprofilevc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabbar"];
        [self.mm_drawerController setCenterViewController:objmyprofilevc withCloseAnimation:YES completion:nil];
    }
    
//    if(indexPath.section == 0) {
//        
//        UITabBarController *obTabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabbar"];
//        [self.mm_drawerController setCenterViewController:obTabbar withCloseAnimation:YES completion:nil];
//    }
    
    else if(indexPath.section == 1) {
        
        UITabBarController *obTabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"navUpload"];
        [self.mm_drawerController setCenterViewController:obTabbar withCloseAnimation:YES completion:nil];
    }
    else if(indexPath.section == 2) {
        
        UploadYourRecipeViewController *obj = (UploadYourRecipeViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FavouritesVC"];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:obj];

        [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
    }
    else{
        
        
        FBSDKLoginManager *loginmanager= [[FBSDKLoginManager alloc]init];
        [loginmanager logOut];
        
        [self performSegueWithIdentifier:@"logoutsegue" sender:nil];
    }
}

#pragma maek -profile view Click

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {

    myprofilevc *obj = (myprofilevc*)[self.storyboard instantiateViewControllerWithIdentifier:@"myprofilevc"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:obj];
    nav.navigationBarHidden = YES;
    [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];

}

@end
