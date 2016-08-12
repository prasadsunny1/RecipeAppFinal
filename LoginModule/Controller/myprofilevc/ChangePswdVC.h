//
//  ChangePswdVC.h
//  LoginModule
//
//  Created by indianic on 03/08/16.
//  Copyright © 2016 creativeIOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePswdVC : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txtFcurrentPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtFNewPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtFconfirmNewPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnSavePassword;

@end
