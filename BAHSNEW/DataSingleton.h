//
//  DataSingleton.h
//  BayAreaHS
//
//  Created by Trevlord on 3/14/13.
//  Copyright (c) 2013 forevorware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSingleton : NSObject
{
    
    CGFloat backGroundR;
    CGFloat backGroundB;
    CGFloat backGroundG;

}

@property (nonatomic, assign) CGFloat backGroundR;
@property (nonatomic, assign) CGFloat backGroundG;
@property (nonatomic, assign) CGFloat backGroundB;
@property (nonatomic, retain) NSMutableArray *counties;
@property (nonatomic, retain) NSMutableDictionary *cities;
@property (nonatomic, retain) NSMutableDictionary *schools;
@property (nonatomic, retain) NSMutableDictionary *rawSchoolList;

+(DataSingleton*)sharedMySingleton;

- (void)makeSchoolDictionary:(NSArray *) schoolList;
- (NSInteger) citiesInCounty:(NSString *) county;
- (NSInteger) schoolsInCity:(NSString *) city andCounty:(NSString *) county;
- (void) filterSchools:(NSString *) criteria;

@end
