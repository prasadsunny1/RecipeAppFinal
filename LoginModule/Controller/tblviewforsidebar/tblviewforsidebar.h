//
//  tblviewforsidebar.h
//  LoginModule
//
//  Created by indianic on 01/08/16.
//  Copyright © 2016 creativeIOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface tblviewforsidebar : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIImageView *imgUserProfileSidebar;
@property (strong, nonatomic) IBOutlet UILabel *lblUserNameSidebar;
@property (strong, nonatomic) IBOutlet UIView *viewUserProfile;
@property (strong, nonatomic) IBOutlet UITableView *tableViewSidebar;

@end
