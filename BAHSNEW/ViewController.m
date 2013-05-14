//
//  ViewController.m
//  BAHS2
//
//  Created by Trevlord on 4/14/13.
//  Copyright (c) 2013 forevorware. All rights reserved.
//

#import "ViewController.h"
#import "TableCell.h"
#import "SchoolMapViewController.h"


@interface ViewController ()

@end

@implementation ViewController


@synthesize theTable, theSearchBar, tableStates, dataSingleton, counties, searchOn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(mapButtonTapped:)];
	self.navigationItem.leftBarButtonItem = mapButton;
    
    self.title = NSLocalizedString(@"Bay Area High Schools", @"Bay Area High Schools");
    
    self.dataSingleton = [DataSingleton sharedMySingleton];
    self.view.backgroundColor = [UIColor colorWithRed:self.dataSingleton.backGroundR green:self.dataSingleton.backGroundG blue:self.dataSingleton.backGroundB alpha:1.0];
    [self resetTableData];
    self.theTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height - 170) style:UITableViewStylePlain];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height)];
    backView.backgroundColor = [UIColor colorWithRed:self.dataSingleton.backGroundR green:self.dataSingleton.backGroundG blue:self.dataSingleton.backGroundB alpha:1.0];
    self.theTable.backgroundView = backView;
    self.theTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.theTable.delegate = self;
    self.theTable.dataSource = self;
    [self.view addSubview:self.theTable];
    
    self.theSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    self.theSearchBar.delegate = self;
    self.theSearchBar.barStyle = UIBarStyleBlack;
    self.theSearchBar.backgroundColor = [UIColor clearColor];
    self.theSearchBar.showsCancelButton = YES;
    [self.view addSubview:self.theSearchBar];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapButtonTapped:(id) sender
{
    SchoolMapViewController *mapView = [[SchoolMapViewController alloc] initWithNibName:@"SchoolMapViewController" bundle:nil];
    mapView.showAll = YES;
    
    [self.navigationController pushViewController:mapView animated:YES];
}


- (void)resetTableData
{
    self.counties = [NSArray arrayWithArray:[[self.dataSingleton.schools allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
    self.tableStates = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    for (NSString *county in self.counties) {
        NSDictionary *cityDict = (NSDictionary *)[self.dataSingleton.schools objectForKey:county];
        NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] initWithCapacity:1];
        for (NSString *city in [cityDict allKeys]) {
            if (self.searchOn) {
                [tmpDict setObject:[NSNumber numberWithBool:true] forKey:city];
            }
            else {
                [tmpDict setObject:[NSNumber numberWithBool:false] forKey:city];
            }
        }
        [self.tableStates setObject:tmpDict forKey:county];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self setSearchOn:NO];
    [self.dataSingleton filterSchools:searchText];
    if (![searchText isEqualToString:@""]) {
        [self setSearchOn:YES];
    }
    
    [self resetTableData];
    [self.theTable reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.theSearchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self setSearchOn:NO];
    [self.dataSingleton filterSchools:@""];
    [self.theSearchBar resignFirstResponder];
    [self resetTableData];
    [self.theTable reloadData];

}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.dataSingleton.schools allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *ret = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 342, 32)];
    
    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(12, 2, 295, 30)];
    lblName.text = [NSString stringWithFormat:@"%@ County", [self.counties objectAtIndex:section]];
    lblName.backgroundColor = [UIColor clearColor];
    [lblName setFont:[UIFont fontWithName:@"Courier-Bold" size:20]];
    lblName.textColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.9 alpha:1.0];
    lblName.shadowColor = [UIColor colorWithRed:0.6 green:0.0 blue:0.0 alpha:1.0];
    lblName.shadowOffset = CGSizeMake(1.0, 1.0);
    [ret addSubview:lblName];
    
    return ret;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}


#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retVal = 0.0f;
    NSString *county = [self.counties objectAtIndex:indexPath.section];
    retVal += 25.0 * [self.dataSingleton citiesInCounty:county];
    
    NSDictionary *cityDict = (NSDictionary *)[self.dataSingleton.schools objectForKey:county];
    for (NSString *city in [cityDict allKeys]) {
        NSDictionary *statesDict1 = [self.tableStates objectForKey:county];
        NSNumber *state = [statesDict1 objectForKey:city];
        if (state.boolValue) {
            retVal += 21.0 * [self.dataSingleton schoolsInCity:city andCounty:county];
        }
    }
    return retVal;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TableCell *cell = (TableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        NSString *county = [self.counties objectAtIndex:indexPath.section];
        
        // Set the Cell height based on the number of cities in the county
        NSDictionary *cities = (NSDictionary *)[self.dataSingleton.schools objectForKey:county];
        CGFloat retVal = 24.0 * [self.dataSingleton citiesInCounty:county];
        
        NSDictionary *cityDict = (NSDictionary *)[self.dataSingleton.schools objectForKey:county];
        for (NSString *city in [cityDict allKeys]) {
            NSDictionary *statesDict = [self.tableStates objectForKey:county];
            NSNumber *state = [statesDict objectForKey:city];
            if (state.boolValue) {
                retVal += 20.0 * [self.dataSingleton schoolsInCity:city andCounty:county];
            }
        }
        
        CGRect newFrame = CGRectMake(25, 0, 300, retVal);
        cell.contentView.frame = newFrame;
        cell.theCounty = county;
        cell.searchOn = self.searchOn;
        cell.tableStates = [NSMutableDictionary dictionaryWithDictionary:[self.tableStates objectForKey:county]];
        [cell setupDataSource:cities withParent:self];
        
        //  Put the subtable in the Table Cell
        cell.tableInCell = [[UITableView alloc] initWithFrame:cell.contentView.frame style:UITableViewStylePlain];
        cell.tableInCell.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *backView = [[UIView alloc] initWithFrame:cell.contentView.frame];
        
        backView.backgroundColor = [UIColor colorWithRed:self.dataSingleton.backGroundR green:self.dataSingleton.backGroundG blue:self.dataSingleton.backGroundB alpha:1.0];
        cell.tableInCell.backgroundView = backView;
        cell.tableInCell.dataSource = cell;
        cell.tableInCell.delegate = cell;
        [cell.contentView addSubview:cell.tableInCell];
    }
    return cell;
}

//  Used by the TableCell when a section header is clicked
- (void)updateTableStatesForCounty:(NSString *) county andCity:(NSString *) city withValue:(NSNumber *) theValue
{
    NSMutableDictionary *cityDict = (NSMutableDictionary *)[self.tableStates objectForKey:county];
    [cityDict setObject:theValue forKey:city];
    [self.tableStates setObject:cityDict forKey:county];
    
    [self.theTable reloadData];
}

- (void)schoolSelected:(NSDictionary *) school
{
    SchoolMapViewController *mapView = [[SchoolMapViewController alloc] initWithNibName:@"SchoolMapViewController" bundle:nil];
    mapView.schoolDict = [NSDictionary dictionaryWithDictionary:school];
    [self.navigationController pushViewController:mapView animated:YES];
}

@end
