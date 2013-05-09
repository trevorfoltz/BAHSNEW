//
//  SchoolImageAnnotation.h
//  BAHS2
//
//  Created by Trevlord on 4/21/13.
//  Copyright (c) 2013 forevorware. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface SchoolImageAnnotation : MKAnnotationView
{
    UILabel *schoolLabel, *mascotLabel;
    NSDictionary *schoolDict;
    
}
@property (nonatomic, retain) UILabel *schoolLabel, *mascotLabel;
@property (nonatomic, retain) NSDictionary *schoolDict;
@end
