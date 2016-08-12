//
//  MKActionTableViewCell.h
//  MKSlidingTableViewCell
//
//  Created by Andrzej Michnia on 14/09/15.
//  Copyright (c) 2015 Michael Kirk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKActionTableViewCell : UITableViewCell

@property (assign, nonatomic, readonly) CGRect actionBounds;
@property (assign, nonatomic) CGFloat revealProgress;
@property (assign, nonatomic, readonly) NSInteger currentStep;
@property (assign, nonatomic) BOOL isBackground;

- (void)didChangedToStep:(NSInteger)step;

@end
