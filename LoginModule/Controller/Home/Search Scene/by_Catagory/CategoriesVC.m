//
//  CategoriesVC.m
//  IosRecipeApp2
//
//  Created by indianic on 21/07/16.
//  Copyright © 2016 indianic. All rights reserved.
//

#import "CategoriesVC.h"
#import "SearchVCTableViewController.h"

@interface CategoriesVC ()<MKSlidingTableViewCellDelegate>
{
    int a;
}
@property (nonatomic, copy) NSMutableArray *data;
@property (nonatomic, strong) MKSlidingTableViewCell *activeCell;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;


@end

@implementation CategoriesVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    a=0;
    //navigation bar methods
   self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Cochin-Italic" size:21], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    //sliding cell methods
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //initializing data defined in recipe
    self.data = [NSMutableArray arrayWithObjects:@{@"cover":@"categoryPunjabi",@"name":@"Punjabi",@"icon":@"cpunjabiicon"},@{@"cover":@"categoryGujarati",@"name":@"Gujarati",@"icon":@"cgujaratiicon"},@{@"cover":@"categorySouthIndian",@"name":@"South Indian",@"icon":@"csouthindianicon"},@{@"cover":@"categoryChinese",@"name":@"Chinese",@"icon":@"cchineseicon"},@{@"cover":@"categoryBakery",@"name":@"Bakery",@"icon":@"cbakeryicon"}, nil];
    
    [self addObservers];

    if ([_isBackOn isEqualToString:@"Yes"])
    {
        self.navigationItem.hidesBackButton = YES;

    }
    else
    {
        self.navigationItem.leftBarButtonItems = nil;
        
    }
   
}

-(void)viewDidAppear:(BOOL)animated
{
   
    
}

#pragma mark - sliding cell methods
- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRevealDrawerViewForCell:) name:MKDrawerDidOpenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHideDrawerViewForCell:) name:MKDrawerDidCloseNotification object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKSlidingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"container"];
    UITableViewCell *foregroundCell = [tableView dequeueReusableCellWithIdentifier:@"foreground"];
    UITableViewCell *backgroundCell = [tableView dequeueReusableCellWithIdentifier:@"background"];
    
   //creating image view
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 182, 128)];
   imageview.image =[UIImage imageNamed:self.data[indexPath.row][@"cover"]];
    
    
    // creating side view
    UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(181, 0, 139, 128)];
    
    //creatig small icon view
    UIImageView *iconview = [[UIImageView alloc]initWithFrame:CGRectMake(47,71,45,38)];
    iconview.image = [UIImage imageNamed:self.data[indexPath.row][@"icon"]];
    iconview.tintColor = [UIColor colorWithRed:0.5451 green: 0.0 blue:0.0 alpha:1.0];
    [cellView addSubview:iconview];
    
    
   // declaring name of categorie
   cell.name  = [[UILabel alloc]initWithFrame:CGRectMake(13, 19, 118, 39)];
    cell.name.text = self.data[indexPath.row][@"name"];
    cell.name.textColor = [UIColor colorWithRed:0.5451 green: 0.0 blue:0.0 alpha:1.0];
    cell.name.font = [UIFont fontWithName:@"Cochin-BoldItalic" size:22.0f];
    [cellView addSubview:cell.name];
   cell.name.textAlignment = NSTextAlignmentCenter;
    

    //creating small white indicator view
    UIView *indicator = [[UIView alloc]initWithFrame:CGRectMake(163, 51, 31, 26)];
    indicator.layer.cornerRadius = 20.0f;
    indicator.backgroundColor = [UIColor whiteColor];
    [cellView  addSubview:indicator];
    [imageview addSubview:indicator];
    
    //defining its own views
    cell.foregroundView = foregroundCell;
    cell.drawerView = backgroundCell;
    cell.drawerRevealAmount = 146;
    cell.delegate = self;
    
    //adding our custom views to foreground
    [foregroundCell addSubview:imageview];
    [foregroundCell addSubview:cellView ];
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKSlidingTableViewCell *cell = (MKSlidingTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UITableViewCell *foregroundCell = (UITableViewCell *)cell.foregroundView;
    
    NSLog(@"Selected cell with text: %@", foregroundCell.textLabel.text);
}

- (void)didSelectSlidingTableViewCell:(MKSlidingTableViewCell *)cell
{

    SearchVCTableViewController *objsVc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchVCTableViewController"];
    objsVc.recipeType = 1;
    objsVc.strCategoryName = [cell.name.text lowercaseString];
    objsVc.strNavTitle = @"Category";
    [self.navigationController pushViewController:objsVc animated:true];
    NSLog(@"Cell tapped %@",cell.name.text);
}

- (void)didRevealDrawerViewForCell:(NSNotification *)notification
{
    MKSlidingTableViewCell *cell = notification.object;
    
    [self.activeCell closeDrawer:nil];
    self.activeCell = cell;
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.tableView addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)didHideDrawerViewForCell:(NSNotification *)notification
{
    MKSlidingTableViewCell *cell = notification.object;
    
    if (cell == self.activeCell)
    {
        self.activeCell = nil;
        [self.tableView removeGestureRecognizer:self.tapGestureRecognizer];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.activeCell closeDrawer:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - background (slided) button methods
- (IBAction)btnCategoriesAddNew:(UIButton *)sender
{
    UploadYourRecipeViewController *objVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadYourRecipeViewController"];
    [self.navigationController pushViewController:objVC animated:YES];
}

- (IBAction)btnCategoriesFav:(UIButton *)sender
{
    a++;
    if(!(a%2==0))
    {
      
        sender.backgroundColor = [UIColor colorWithRed:(0.0/255.0) green:(100.0/255.0) blue:(0.0/255.0) alpha:1.0];
       
    }
    else
    {
       sender.backgroundColor = [UIColor colorWithRed:(159.0/255.0) green:(7.0/255.0) blue:(18.0/255.0) alpha:1.0];

    }

}

- (IBAction)btnCategoriesPopular:(UIButton *)sender {
    
    HomeVC *objVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
    objVC.isBackOn = @"Yes";
    [self.navigationController pushViewController:objVC animated:YES];
    
}


#pragma mark- bar button tapped methods 
- (IBAction)onBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDrawer:(UIBarButtonItem *)sender
{
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}
@end
