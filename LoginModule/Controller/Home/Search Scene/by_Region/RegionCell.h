//
//  RegionCell.h
//  LoginModule
//
//  Created by indianic on 03/08/16.
//  Copyright © 2016 creativeIOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgRegionCover;
@property (strong, nonatomic) IBOutlet UILabel *lblRegionName;
@property (strong, nonatomic) IBOutlet UILabel *lblRegionDesc;

@end
