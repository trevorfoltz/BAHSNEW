//
//  SchoolAnnotation.h
//  BAHS2
//
//  Created by Trevlord on 4/18/13.
//  Copyright (c) 2013 forevorware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SchoolAnnotation : NSObject <MKAnnotation>
{
    NSNumber *latitude;
    NSNumber *longitude;
    NSString *titleStr;
    NSString *subTitleStr;
    CGFloat xOffset, yOffset;
    NSDictionary *schoolDict;
    
}

@property (nonatomic, retain) NSDictionary *schoolDict;
@property (nonatomic, assign) CGFloat xOffset, yOffset;

@property (nonatomic, retain) NSString *titleStr;
@property (nonatomic, retain) NSString *subTitleStr;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;


@end
