//
//  IngResultNameCell.m
//  LoginModule
//
//  Created by indianic on 02/08/16.
//  Copyright © 2016 creativeIOS. All rights reserved.
//

#import "IngResultNameCell.h"

@implementation IngResultNameCell

-(void)setHighlighted:(BOOL)highlighted
{
    if (highlighted)
    {
        self.layer.opacity = 0.2;
        //or whatever you want here
    }

    
}

@end
