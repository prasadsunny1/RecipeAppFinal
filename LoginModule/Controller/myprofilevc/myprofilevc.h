//
//  myprofilevc.h
//  LoginModule
//
//  Created by Meet Shah on 8/2/16.
//  Copyright © 2016 creativeIOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"

@interface myprofilevc : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *myimg;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblUserEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnChangePassword;

@end
