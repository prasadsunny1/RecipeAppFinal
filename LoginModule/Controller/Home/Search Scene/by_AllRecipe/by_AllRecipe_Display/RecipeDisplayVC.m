//
//  RecipeDisplayVC.m
//  IosRecipeApp2
//
//  Created by indianic on 22/07/16.
//  Copyright © 2016 indianic. All rights reserved.
//

#import "RecipeDisplayVC.h"



@interface RecipeDisplayVC ()
{
    int a;
    NSMutableArray *arrIngredientTable;
}
@end

@implementation RecipeDisplayVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // navigation bar methods
    self.navigationItem.title = _strNavTitle;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Cochin-Italic" size:21], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
   
    
    // drop down menu  methods
    CGRect frame = CGRectMake(0, 253, 320, 34);
    NSLog(@"result is %@", _result);
   _menu1 = [[ManaDropDownMenu alloc] initWithFrame:frame title:@"Ingredients with Quantity"];
    _menu1.delegate = self;
    
    NSMutableArray *ing = [NSMutableArray array];
    NSMutableArray *ingforQuan = [NSMutableArray array];
    
    //array for ingredient table
    arrIngredientTable=[NSMutableArray new];
    
    
    NSMutableDictionary *ingquant  = [NSMutableDictionary dictionary];
    for (NSMutableDictionary *ingredientquant in [_result valueForKey:@"ingredient_quantity"]) {
        
        [ingquant setValue:ingredientquant forKey:@"recipeing1"];
        
        
        [ingforQuan addObject:_result[@"ingredient_quantity"][ingquant[@"recipeing1"]]];
        
    }
    NSLog(@"ingforQuan %@",ingforQuan);

    
    NSMutableDictionary *ingname  = [NSMutableDictionary dictionary];
    for (NSMutableDictionary *ingredient in [_result valueForKey:@"ingredient"])
    {
        [ingname setValue:ingredient forKey:@"recipeing"];
       
      
        [ing addObject:_result[@"ingredient"][ingname[@"recipeing"]]];
        
    }
    NSLog(@"ing %@",ing);
    
    _menu1.numberOfRows = ing.count;
    
    for (int i=0; i<ing.count; i++)
    {
       
        [arrIngredientTable addObject:[NSString stringWithFormat:@"%@-%@",ing[i],ingforQuan[i]]];
    }
    
    _menu1.textOfRows = arrIngredientTable;
    
   [self.view addSubview:_menu1];


 }

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload
{
    [self setLblRecipeDisplayName:nil];
    
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    
    [_RecipeDisplayCoverPhoto setImageWithURL:[NSURL URLWithString:[_result valueForKey:@"coverimage"]]placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    
    //recipe name text and display properties
    _lblRecipeDisplayName.text = [_result valueForKey:@"name"];
    _lblRecipeDisplayName.layer.borderWidth = 1.0;
    _lblRecipeDisplayName.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.3].CGColor;
    _lblRecipeDisplayName.userInteractionEnabled = false;

    
    //recipe cooking time text and display properties
    _lblRecipeDisplayCookingTime.text = [_result valueForKey:@"time"];
    _lblRecipeDisplayCookingTime.userInteractionEnabled = false;
    
    //recipe serves text and display properties
    _lblRecipeDisplayServes.text = [_result valueForKey:@"serves"];
    _lblRecipeDisplayServes.userInteractionEnabled = false;
    
    //recipe cooking location text and display properties
    _lblRecipeDisplayLocationName.text = [_result valueForKey:@"location"];
    _lblRecipeDisplayLocationName.userInteractionEnabled = false;
    
    //recipe category text and display properties
    _lblRecipeDisplayCategory.text = [_result valueForKey:@"category"];
    _lblRecipeDisplayLocationName.userInteractionEnabled = false;

    
    
    //recipe author name text and display properties
    _lblRecipeDisplayAuthorName.text = [NSString stringWithFormat:@"Recipe By : %@...", [_result valueForKey:@"author"]];
    _lblRecipeDisplayAuthorName.layer.borderWidth = 1.0;
    _lblRecipeDisplayAuthorName.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.3].CGColor;
    _lblRecipeDisplayAuthorName.userInteractionEnabled = false;

    
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[_result valueForKey:@"steps"]count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //setting whole table view background color
    tableView.backgroundColor = [UIColor whiteColor];
    
    //initializing custom cell of table view
    static NSString *CellIdentifier = @"RecipeDisplayStepsTableViewCell";
    RecipeDisplayStepsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //setting whole custome cell background color
    cell.backgroundColor = [UIColor whiteColor];
    
    
    // getting values for recipe description for recipe that has been selected in SearchVCTableViewController
    
    NSMutableArray *stepdetaildesc = [NSMutableArray array]; // array for recipe step description
    NSMutableArray *stepdetailimage = [NSMutableArray array]; // // array for recipe step image

    //getting respective values from dictionary
    NSMutableDictionary *stepdesc = [NSMutableDictionary dictionary];
    for (NSMutableDictionary *step in [_result valueForKey:@"steps"]) {
        
        [stepdesc setValue:step forKey:@"dic"];
        [stepdetaildesc addObject:_result[@"steps"][stepdesc[@"dic"]][@"discription"]];
        [stepdetailimage addObject:_result[@"steps"][stepdesc[@"dic"]][@"image"]];
        
    }
    
    //setting step description cell value and properties from stepdetaildesc array
    cell.RecipeDisplayStepDescCell.text = stepdetaildesc[indexPath.row];
    cell.RecipeDisplayStepDescCell.userInteractionEnabled = false;
    
     //setting step description image and properties from stepdetailimage array
    [cell.RecipeDisplayStepCellImg setImageWithURL:[NSURL URLWithString:stepdetailimage[indexPath.row]]placeholderImage:nil];
    cell.RecipeDisplayStepCellImg.layer.cornerRadius = 15.0f;
    cell.RecipeDisplayStepCellImg.layer.masksToBounds = YES;
    cell.RecipeDisplayStepCellImg.layer.borderWidth = 3.0;
    cell.RecipeDisplayStepCellImg.layer.borderColor = [UIColor colorWithRed:0.5451 green: 0.0 blue:0.0 alpha:1.0].CGColor;
    
    
    
    //setting step no and its properties
    cell.RecipeDisplayStepNoCell.text = [NSString stringWithFormat:@" Step No: %ld",   (long)indexPath.row+1];
   cell.RecipeDisplayStepNoCell.userInteractionEnabled = false;

    

    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UIBarButton on tapped pop VC 

- (IBAction)btnBarButtonBack:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

#pragma mark - Favourite And Share buttons on tapped

- (IBAction)btnFavourites:(UIButton *)sender {
    
    
    a++;
    if(a%2==0)
    {
        _isOn = NO;
        [_favouriteProp setImage:[UIImage imageNamed:@"hearts.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        _isOn = YES;
        
        [_favouriteProp setImage:[UIImage imageNamed:@"heartsadded.png"] forState:UIControlStateNormal];
    }

}

- (IBAction)btnShare:(UIButton *)sender {

   
    
    a++;
    if(a%2==0)
    {
        
        _isOn = NO;
        [_shareProp setImage:[UIImage imageNamed:@"sharesadded.png"] forState:UIControlStateNormal];
       
    }
    else
    {
        _isOn = YES;
        [_shareProp setImage:[UIImage imageNamed:@"shares.png"] forState:UIControlStateNormal];
    }
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Share" message:@"Select Your Choice" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Share Via Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
    {
        if(![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            //
            
            [controller addURL:[NSURL URLWithString:@"https://github.com/prasadsunny1/RecipeAppFinal"]];
            [controller setInitialText:[NSString stringWithFormat:@"Hey! Check out this new exciting recipe %@",[_result valueForKey:@"name"]]];
            [controller addImage:_RecipeDisplayCoverPhoto.image];
            [self presentViewController:controller animated:YES completion:Nil];
        }

    }];
   
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Share Via Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
    {
                if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
                {
                    SLComposeViewController *tweetSheet = [SLComposeViewController
                                                           composeViewControllerForServiceType:SLServiceTypeTwitter];
                    [tweetSheet setInitialText:[NSString stringWithFormat:@"Hey! Check out this new exciting recipe %@",[_result valueForKey:@"name"]]];
                    [tweetSheet addImage:_RecipeDisplayCoverPhoto.image];
                    [tweetSheet addURL:[NSURL URLWithString:@"https://github.com/prasadsunny1/RecipeAppFinal"]];
                    [self presentViewController:tweetSheet animated:YES completion:nil];
                }
      }];
    
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Share Via Mail" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
     {
         NSString *emailTitle = @"Shared A Recipe With Recipe App";
         NSString *messageBody = [NSString stringWithFormat:@"Hey! Check out this exciting recipe named %@ \n %@",[_result valueForKey:@"name"],[NSURL URLWithString:[_result valueForKey:@"coverimage"]]];
         
         NSArray *toRecipents = [NSArray arrayWithObject:[AppDelegate sharedInstance].userEmail];
         
         MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
         mc.mailComposeDelegate = self;
         [mc setSubject:emailTitle];
         [mc setMessageBody:messageBody isHTML:NO];
         [mc setToRecipients:toRecipents];
         
         [self presentViewController:mc animated:YES completion:NULL];
         
                                      
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleDefault handler:nil];

    
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [alert addAction:thirdAction];
    [alert addAction:cancle];
    
    [self presentViewController:alert animated:YES completion:nil];
  
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
           [[AppDelegate sharedInstance]showAlertInController:self WithMessage:@"Mail Has Benn Cancled"];
            break;
        case MFMailComposeResultSaved:
            [[AppDelegate sharedInstance]showAlertInController:self WithMessage:@"Mail Saved"];
            break;
        case MFMailComposeResultSent:
            [[AppDelegate sharedInstance]showAlertInController:self WithMessage:@"Mail Sent"];
            break;
        case MFMailComposeResultFailed:
           [[AppDelegate sharedInstance]showAlertInController:self WithMessage:@"Mail Sending Failed. \n Please try again"];
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - on drawer button tapped
- (IBAction)onDrawer:(UIBarButtonItem *)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}
@end
