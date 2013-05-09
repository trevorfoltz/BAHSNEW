//
//  TableCell.h
//  TestTableApp
//
//  Created by Trevlord on 3/27/13.
//  Copyright (c) 2013 forevorware. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewController.h"

@interface TableCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>
{
    NSDictionary *cityDict;
    NSMutableDictionary *tableStates;
    ViewController *masterView;
    NSString *theCounty;
    NSArray *cities, *schools;
    BOOL searchOn;
}

@property (nonatomic, assign) BOOL searchOn;
@property (nonatomic, retain) NSArray *cities, *schools;
@property (nonatomic, retain) NSString *theCounty;;
@property (nonatomic, retain) UITableView *tableInCell;
@property (nonatomic, retain) ViewController *masterView;
@property (nonatomic, retain) NSDictionary *cityDict;
@property (nonatomic, retain) NSMutableDictionary *tableStates;

- (void) setupDataSource:(NSDictionary *) theDict withParent:(ViewController *) parent;

@end
