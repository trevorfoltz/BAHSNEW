//
//  ViewController.h
//  BAHS2
//
//  Created by Trevlord on 4/14/13.
//  Copyright (c) 2013 forevorware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSingleton.h"

@interface ViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    NSMutableDictionary *tableStates;
    IBOutlet UITableView *theTable;
    UISearchBar *theSearchBar;
    NSArray *counties;
    BOOL searchOn;
}
@property (nonatomic, assign) BOOL searchOn;
@property (nonatomic, retain) NSArray *counties;
@property (nonatomic, retain) IBOutlet UITableView *theTable;
@property (nonatomic, retain) NSMutableDictionary *tableStates;
@property (strong, nonatomic) DataSingleton *dataSingleton;
@property (nonatomic, retain) UISearchBar *theSearchBar;

- (void)resetTableData;
- (void)updateTableStatesForCounty:(NSString *) county andCity:(NSString *) city withValue:(NSNumber *) value;
- (void)schoolSelected:(NSDictionary *) school;

@end
