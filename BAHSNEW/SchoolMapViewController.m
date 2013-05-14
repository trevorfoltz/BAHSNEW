//
//  SchoolMapViewController.m
//  BAHS2
//
//  Created by Trevlord on 4/18/13.
//  Copyright (c) 2013 forevorware. All rights reserved.
//

#import "SchoolMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SchoolAnnotation.h"
#import "SchoolImageAnnotation.h"

@interface SchoolMapViewController ()

@end

@implementation SchoolMapViewController

@synthesize mapView, schoolDict, xOffset, yOffset;
@synthesize customCallout, calloutOpen, showAll, sharedSingleton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *)parseSchoolName:(NSString *) name
{
    NSMutableString *retVal = [NSMutableString stringWithString:@""];
    NSArray *wordsInName = [name componentsSeparatedByString:@" "];
    for (NSString *word in wordsInName) {
        [retVal appendString:[word substringToIndex:1]];
    }
    [retVal appendString:@"HS"];
    return (NSString *)retVal;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.mapView.mapType = MKMapTypeHybrid;
    UITapGestureRecognizer *touchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedOnce:)];
    
    touchGesture.numberOfTapsRequired = 1;
    touchGesture.numberOfTouchesRequired = 1;
    
    [self.view addGestureRecognizer:touchGesture];
    if (self.showAll) {
        CLLocationDegrees lat = 37.92493;
        CLLocationDegrees lon = -122.3286;
        CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(lat, lon);
        self.mapView.region = MKCoordinateRegionMake(centerCoord, MKCoordinateSpanMake(1.0, 1.0));
        self.title = @"Bay Area High Schools";
        
        self.sharedSingleton = [DataSingleton sharedMySingleton];
        for (NSString *school in [[self.sharedSingleton rawSchoolList] allKeys]) {
            NSDictionary *tempDict = (NSDictionary *)[self.sharedSingleton.rawSchoolList objectForKey:school];
            NSString *locLat = [tempDict objectForKey:@"lat"];
            NSString *locLon = [tempDict objectForKey:@"lon"];
            SchoolAnnotation *theAnnotation = [[SchoolAnnotation alloc] init];
            NSString *tempStr = [self parseSchoolName:[tempDict objectForKey:@"school"]];
            theAnnotation.titleStr = tempStr;
            theAnnotation.latitude = [NSNumber numberWithDouble:[locLat doubleValue]];
            theAnnotation.longitude = [NSNumber numberWithDouble:[locLon doubleValue]];
            theAnnotation.schoolDict = [NSDictionary dictionaryWithDictionary:tempDict];
            [self.mapView addAnnotation:theAnnotation];
            
        }
        
    }
    else {
        self.title = [self.schoolDict objectForKey:@"school"];
        NSString *locLat = [self.schoolDict objectForKey:@"lat"];
        CLLocationDegrees locLatVal = (CLLocationDegrees) [locLat doubleValue];
        NSString *locLon = [self.schoolDict objectForKey:@"lon"];
        CLLocationDegrees locLonVal = (CLLocationDegrees) [locLon doubleValue];
        CLLocationCoordinate2D locCoord = CLLocationCoordinate2DMake(locLatVal, locLonVal);
        [self.mapView setRegion:MKCoordinateRegionMake(locCoord, MKCoordinateSpanMake(1.0, 1.0)) animated:YES];
        
        [self performSelector:@selector(showAnnotation:) withObject:nil afterDelay:2.0];
    }
}

- (void)goBack:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)touchedOnce:(id) sender
{
    if (self.calloutOpen) {
        [self.customCallout hideDetails];
        [self setCalloutOpen:NO];
    }
    
}

- (void) showAnnotation:(id) sender
{
    NSString *locLat = [self.schoolDict objectForKey:@"lat"];
    CLLocationDegrees locLatVal = (CLLocationDegrees) [locLat doubleValue];
    NSString *locLon = [self.schoolDict objectForKey:@"lon"];
    CLLocationDegrees locLonVal = (CLLocationDegrees) [locLon doubleValue];
    
    CLLocationCoordinate2D locCoord = CLLocationCoordinate2DMake(locLatVal, locLonVal);
    [self.mapView setRegion:MKCoordinateRegionMake(locCoord, MKCoordinateSpanMake(0.005, 0.005)) animated:YES];
    SchoolAnnotation *theAnnotation = [[SchoolAnnotation alloc] init];
    theAnnotation.titleStr = [self.schoolDict objectForKey:@"school"];
    theAnnotation.subTitleStr = [self.schoolDict objectForKey:@"mascot"];
    theAnnotation.latitude = [NSNumber numberWithDouble:[locLat doubleValue]];
    theAnnotation.longitude = [NSNumber numberWithDouble:[locLon doubleValue]];
    
    [self.mapView addAnnotation:theAnnotation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)longestStringValue:(NSDictionary *) school
{
    NSString *strVal = [school objectForKey:@"school"];
    NSInteger retVal = [strVal length];
    strVal = [school objectForKey:@"address"];
    if ([strVal length] > retVal) {
        retVal = [strVal length];
    }
    return retVal;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MKAnnotationView *tmpView = (MKAnnotationView *) view;
    [tmpView setSelected:NO animated:NO];
    if (self.calloutOpen) {
        [self.customCallout hideDetails];
        [self setCalloutOpen:NO];
        if (!self.showAll) {
            return;
        }
    
    }
    self.customCallout = [[DetailView alloc] initWithNibName:@"DetailView" bundle:nil];
    self.customCallout.view.frame = CGRectMake(150, 250, 170, 120);
    
    self.customCallout.view.alpha = 0.0;
    SchoolImageAnnotation *tempAnnot = (SchoolImageAnnotation *) view;
    
    if (self.showAll) {
        NSString *addr = [tempAnnot.schoolDict objectForKey:@"address"];
        if ([addr length] > 21) {
            self.customCallout.view.frame = CGRectMake(120, 250, 200, 120);
        }
        self.customCallout.schoolLabel.text = [tempAnnot.schoolDict objectForKey:@"school"];
        self.customCallout.mascotLabel.text = [tempAnnot.schoolDict objectForKey:@"mascot"];
        self.customCallout.addressLabel.text = [tempAnnot.schoolDict objectForKey:@"address"];
        self.customCallout.cityLabel.text = [NSString stringWithFormat:@"%@, CA", [tempAnnot.schoolDict objectForKey:@"city"]];
        self.customCallout.countyLabel.text = [NSString stringWithFormat:@"%@ County", [tempAnnot.schoolDict objectForKey:@"county"]];
        self.customCallout.phoneLabel.text = [tempAnnot.schoolDict objectForKey:@"phone"];
    }
    else {
        NSString *addr = [schoolDict objectForKey:@"address"];
        if ([addr length] > 21) {
            self.customCallout.view.frame = CGRectMake(120, 250, 200, 120);
        }
        self.customCallout.schoolLabel.text = [schoolDict objectForKey:@"school"];
        self.customCallout.mascotLabel.text = [schoolDict objectForKey:@"mascot"];
        self.customCallout.addressLabel.text = [schoolDict objectForKey:@"address"];
        self.customCallout.cityLabel.text = [NSString stringWithFormat:@"%@, CA", [schoolDict objectForKey:@"city"]];
        self.customCallout.countyLabel.text = [NSString stringWithFormat:@"%@ County", [schoolDict objectForKey:@"county"]];
        self.customCallout.phoneLabel.text = [schoolDict objectForKey:@"phone"];
    }
    [self.view addSubview:self.customCallout.view];
    [self.customCallout showDetails];
    [self setCalloutOpen:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[SchoolAnnotation class]]) {
        SchoolAnnotation *theAnnotation = (SchoolAnnotation *) annotation;
        // try to dequeue an existing pin view first
        NSString *SchoolAnnotationIdentifier = [NSString stringWithFormat:@"SchoolAnnotationIdentifier%@%@", [theAnnotation.schoolDict objectForKey:@"lat"], [theAnnotation.schoolDict objectForKey:@"lon"]];
        SchoolImageAnnotation *pinView = (SchoolImageAnnotation *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:SchoolAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            
            pinView = [[SchoolImageAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:SchoolAnnotationIdentifier];
            pinView.canShowCallout = NO;
            pinView.enabled = YES;
            
            
            if (self.showAll) {
                pinView.image = [UIImage imageNamed:@"smallpin2.png"];
                pinView.schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 50, 20)];
                pinView.schoolLabel.backgroundColor = [UIColor clearColor];
                pinView.schoolLabel.textColor = [UIColor whiteColor];
                
                pinView.schoolLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10.0];
                pinView.schoolDict = [NSDictionary dictionaryWithDictionary:theAnnotation.schoolDict];
            }
            else {
                pinView.image = [UIImage imageNamed:@"bigpin.png"];
                pinView.mascotLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 25, 140, 20)];
                pinView.mascotLabel.backgroundColor = [UIColor clearColor];
                pinView.mascotLabel.textColor = [UIColor whiteColor];
                pinView.mascotLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                pinView.mascotLabel.shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
                pinView.mascotLabel.shadowOffset = CGSizeMake(1.0, 1.0);
                pinView.mascotLabel.textAlignment = NSTextAlignmentCenter;
                pinView.mascotLabel.text = theAnnotation.subTitleStr;
                [pinView addSubview:pinView.mascotLabel];
                pinView.schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 140, 20)];
                pinView.schoolLabel.backgroundColor = [UIColor clearColor];
                pinView.schoolLabel.textColor = [UIColor whiteColor];
                pinView.schoolLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
            }
            pinView.schoolLabel.textAlignment = NSTextAlignmentCenter;
            pinView.schoolLabel.shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
            pinView.schoolLabel.shadowOffset = CGSizeMake(1.0, 1.0);
            pinView.schoolLabel.text = theAnnotation.titleStr;
            [pinView addSubview:pinView.schoolLabel];
            return pinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }  
    return nil;
}

@end
