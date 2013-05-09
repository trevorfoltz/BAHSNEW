//
//  DetailView.h
//  BAHS2
//
//  Created by Trevlord on 4/21/13.
//  Copyright (c) 2013 forevorware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailView : UIViewController
{
    IBOutlet UILabel *schoolLabel, *addressLabel, *cityLabel, *countyLabel, *mascotLabel, *phoneLabel;
    
    
    
    
}

@property (nonatomic, retain) IBOutlet UILabel *schoolLabel, *addressLabel, *cityLabel, *countyLabel, *mascotLabel, *phoneLabel;

- (void)showDetails;
- (void)hideDetails;

@end
