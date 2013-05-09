//
//  SchoolAnnotation.m
//  BAHS2
//
//  Created by Trevlord on 4/18/13.
//  Copyright (c) 2013 forevorware. All rights reserved.
//

#import "SchoolAnnotation.h"

@implementation SchoolAnnotation

@synthesize latitude, longitude, titleStr, subTitleStr, xOffset, yOffset;
@synthesize schoolDict;

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [self.latitude doubleValue];
    theCoordinate.longitude = [self.longitude doubleValue];
    return theCoordinate;
}

- (NSString *) title
{
    return self.titleStr;
}

- (NSString *) subtitle
{
    return self.subTitleStr;
}

@end
