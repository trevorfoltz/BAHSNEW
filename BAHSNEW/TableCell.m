//
//  TableCell.m
//  TestTableApp
//
//  Created by Trevlord on 3/27/13.
//  Copyright (c) 2013 forevorware. All rights reserved.
//

#import "TableCell.h"
#import "DataSingleton.h"

@interface TableCell ()

@end

@implementation TableCell


@synthesize cityDict, tableInCell, tableStates, masterView, theCounty;
@synthesize cities, schools, searchOn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)didPressCity:(UIButton*)sender
{
    NSString *city = [self.cities objectAtIndex:sender.tag];
    NSNumber *state = [self.tableStates objectForKey:city];
    state = [NSNumber numberWithBool:!state.boolValue];
    [self.tableStates setObject:state forKey:city];
    [self.masterView updateTableStatesForCounty:self.theCounty andCity:city withValue:state];
}


- (void) setupDataSource:(NSDictionary *) theDict withParent:(ViewController *) parent
{
    self.masterView = parent;
    self.cityDict = [NSDictionary dictionaryWithDictionary:theDict];
    self.cities = [NSArray arrayWithArray:[[self.cityDict allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.cityDict allKeys] count];

}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DataSingleton *dataSingleton = [DataSingleton sharedMySingleton];
    
    NSString *city = [self.cities objectAtIndex:section];
    
    UIView *ret = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 342, 22)];
    
    ret.backgroundColor = [UIColor colorWithRed:dataSingleton.backGroundR green:dataSingleton.backGroundG blue:dataSingleton.backGroundB alpha:1.0];
    
    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, 295, 20)];
    lblName.text = city;
    lblName.backgroundColor = [UIColor clearColor];
    lblName.font = [UIFont fontWithName:@"Courier" size:18];
    lblName.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:1.0 alpha:1.0];
    lblName.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.6 alpha:1.0];
    lblName.shadowOffset = CGSizeMake(1.0, 1.0);
    [ret addSubview:lblName];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = ret.frame;
    btn.tag = section;
    [btn addTarget:self action:@selector(didPressCity:) forControlEvents:UIControlEventTouchUpInside];
    [ret addSubview:btn];
    
    return ret;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *city = [self.cities objectAtIndex:section];
    NSNumber *state = [self.tableStates objectForKey:city];

    if (state.boolValue) {
        NSDictionary *schoolDict = (NSDictionary *)[self.cityDict objectForKey:city];
        return [[schoolDict allKeys] count];
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indentationLevel = 0.25;
    cell.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    cell.textLabel.font = [UIFont fontWithName:@"Courier-Bold" size:16];
    cell.textLabel.textColor = [UIColor colorWithRed:0.9 green:1.0 blue:0.9 alpha:1.0];
    cell.textLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0];
    cell.textLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    
    NSString *cityKey = [self.cities objectAtIndex:indexPath.section];
    NSDictionary *schoolDict = (NSDictionary *)[self.cityDict objectForKey:cityKey];
    
    NSArray *sortedSchools = [NSArray arrayWithArray:[[schoolDict allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
    NSDictionary *school = (NSDictionary *) [schoolDict objectForKey:[sortedSchools objectAtIndex:indexPath.row]];
    NSString *schoolName = [school objectForKey:@"school"];
    NSString *mascot = [school objectForKey:@"mascot"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", schoolName, [school objectForKey:@"mascot"]];
    if ([mascot isEqualToString:@""]) {
        cell.textLabel.text = schoolName;
    }
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cityKey = [self.cities objectAtIndex:indexPath.section];
    NSDictionary *schoolDict = (NSDictionary *)[self.cityDict objectForKey:cityKey];
    NSArray *sortedSchools = [NSArray arrayWithArray:[[schoolDict allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
    NSDictionary *theSchoolDict = (NSDictionary *)[schoolDict objectForKey:[sortedSchools objectAtIndex:indexPath.row]];
    [self.masterView schoolSelected:theSchoolDict];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
