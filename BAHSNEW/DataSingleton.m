//
//  DataSingleton.m
//  BayAreaHS
//
//  Created by Trevlord on 3/14/13.
//  Copyright (c) 2013 forevorware. All rights reserved.
//

#import "DataSingleton.h"

static DataSingleton * _sharedCurrentUserSingleton;

@implementation DataSingleton

@synthesize backGroundB, backGroundG, backGroundR;

+(DataSingleton*)sharedMySingleton
{
	@synchronized([DataSingleton class])
	{
		if (!_sharedCurrentUserSingleton)
            (void)[[self alloc] init];
        
		return _sharedCurrentUserSingleton;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([DataSingleton class])
	{
		NSAssert(_sharedCurrentUserSingleton == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedCurrentUserSingleton = [super alloc];
        
		return _sharedCurrentUserSingleton;
	}
    
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
        self.backGroundR = 0.0;
        self.backGroundG = 0.0;
        self.backGroundB = 0.0;
        
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Schools" ofType:@"plist"];
        
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        self.rawSchoolList = [NSMutableDictionary dictionaryWithDictionary:(NSMutableDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc]];
        NSMutableArray *schoolList = [[NSMutableArray alloc] initWithCapacity:1];
        for (NSString *key in [self.rawSchoolList allKeys]) {
            NSDictionary *tempDict = [self.rawSchoolList objectForKey:key];
            [schoolList addObject:tempDict];
        }
        [self makeSchoolDictionary:schoolList];
	}
    return self;
}


- (void)makeSchoolDictionary:(NSArray *) schoolList
{
    NSMutableArray *countyList = [[NSMutableArray alloc] initWithCapacity:1];
    for (NSDictionary *schoolDict in schoolList) {
        NSString *county = [schoolDict objectForKey:@"county"];
        if (![countyList containsObject:county]) {
            [countyList addObject:county];
        }
    }
    self.counties = [NSMutableArray arrayWithArray:[countyList sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
    
    self.cities = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    for (int i = 0; i< [self.counties count]; i++) {
        NSString *county = [self.counties objectAtIndex:i];
        NSString *countyName = nil;
        NSMutableArray *cityList = [[NSMutableArray alloc] initWithCapacity:1];
        for (NSDictionary *schoolDict in schoolList) {
            countyName = [schoolDict objectForKey:@"county"];
            if ([county isEqualToString:countyName]) {
                NSString *city = [schoolDict objectForKey:@"city"];
                if (![cityList containsObject:city]) {
                    [cityList addObject:city];
                }
            }
        }
        [self.cities setObject:cityList forKey:county];
    }
    
    self.schools = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    for (NSString *county in [self.cities allKeys]) {
        NSArray *cityList = (NSArray *)[self.cities objectForKey:county];
        NSMutableDictionary *tmpCityDict = [[NSMutableDictionary alloc] initWithCapacity:1];
        for (NSString *city in cityList) {
            NSMutableDictionary *tmpSchoolDict = [[NSMutableDictionary alloc] initWithCapacity:1];
            for (NSDictionary *schoolDict in schoolList) {
                if ([county isEqualToString:[schoolDict objectForKey:@"county"]] && [city isEqualToString:[schoolDict objectForKey:@"city"]] && ![[tmpSchoolDict allKeys] containsObject:[schoolDict objectForKey:@"school"]]) {
                    [tmpSchoolDict setObject:schoolDict forKey:[schoolDict objectForKey:@"school"]];
                }
            }
            [tmpCityDict setObject:tmpSchoolDict forKey:city];
        }
        [self.schools setObject:tmpCityDict forKey:county];
    }

}

- (void)filterSchools:(NSString *) criteria
{
    NSMutableArray *schoolList = [[NSMutableArray alloc] initWithCapacity:1];
    for (NSString *key in [self.rawSchoolList allKeys]) {
        NSDictionary *tempDict = [self.rawSchoolList objectForKey:key];
        if (![criteria isEqualToString:@""]) {
            NSString *city = (NSString *)[tempDict objectForKey:@"city"];
            NSRange cityRange = [city rangeOfString:criteria];
            NSString *school = (NSString *)[tempDict objectForKey:@"school"];
            NSRange schoolRange = [school rangeOfString:criteria];
            if (cityRange.length > 0 || schoolRange.length > 0) {
                [schoolList addObject:tempDict];
            }
        }
        else {
            [schoolList addObject:tempDict];
        }
    }
    [self makeSchoolDictionary:schoolList];
    
}

- (NSInteger) citiesInCounty:(NSString *) county
{
    NSDictionary *cityDict = (NSDictionary *)[self.schools objectForKey:county];
    return [[cityDict allKeys] count];
}

- (NSInteger) schoolsInCity:(NSString *) city andCounty:(NSString *) county
{
    NSDictionary *cityDict = (NSDictionary *)[self.schools objectForKey:county];
    NSDictionary *schoolDict = (NSDictionary *)[cityDict objectForKey:city];
    return [[schoolDict allKeys] count];
}

@end
