//
//  SchoolMapViewController.h
//  BAHS2
//
//  Created by Trevlord on 4/18/13.
//  Copyright (c) 2013 forevorware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DetailView.h"
#import "DataSingleton.h"

@interface SchoolMapViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate>
{
    DataSingleton *sharedSingleton;
    IBOutlet MKMapView *mapView;
    NSDictionary *schoolDict;
    CGFloat xOffset, yOffset;
    DetailView *customCallout;
    BOOL calloutOpen, showAll;
}

@property (nonatomic, retain) DataSingleton *sharedSingleton;
@property (nonatomic, assign) BOOL calloutOpen, showAll;
@property (nonatomic, retain) DetailView *customCallout;
@property (nonatomic, assign) CGFloat xOffset, yOffset;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSDictionary *schoolDict;


@end
