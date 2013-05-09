//
//  DetailView.m
//  BAHS2
//
//  Created by Trevlord on 4/21/13.
//  Copyright (c) 2013 forevorware. All rights reserved.
//

#import "DetailView.h"

@implementation DetailView

@synthesize schoolLabel, cityLabel, countyLabel, mascotLabel, addressLabel, phoneLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)showDetails
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:1.0];
    self.view.alpha = 1.0;
    [UIView commitAnimations];
    
}

- (void)hideDetails
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:1.0];
    self.view.alpha = 0.0;
    [UIView commitAnimations];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
