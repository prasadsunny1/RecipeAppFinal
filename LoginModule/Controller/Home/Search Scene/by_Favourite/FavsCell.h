//
//  FavsCell.h
//  LoginModule
//
//  Created by indianic on 02/08/16.
//  Copyright © 2016 creativeIOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavsCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgOfFavs;
@property (strong, nonatomic) IBOutlet UILabel *lblFavName;
@property (strong, nonatomic) IBOutlet UILabel *lblIhavegot;
@property (strong, nonatomic) IBOutlet UILabel *lblMinutes;

@end
