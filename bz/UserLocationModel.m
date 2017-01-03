//
//  UserLocationModel.m
//  bz
//
//  Created by qianchuang on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "UserLocationModel.h"
#import "BMKTypes.h"

@implementation UserLocationModel

//- (instancetype)initWithBMKAddressComponent:(BMKAddressComponent *)compoent
//{
//    if (self = [super init]) {
//        _streetName = compoent.streetName;
//        _streetNumber = compoent.streetNumber;
//        _district = compoent.district;
//        _city = compoent.city;
//        _province = compoent.province;
//        _country = compoent.country;
//        _countryCode = compoent.countryCode;
//    }
//    
//    return self;
//}

- (void)setBMKAddressComponent:(BMKAddressComponent *)compoent andLocation:(CLLocationCoordinate2D)location
{
    _streetName = compoent.streetName;
    _streetNumber = compoent.streetNumber;
    _district = compoent.district;
    _city = compoent.city;
    _province = compoent.province;
    _country = compoent.country;
    _countryCode = compoent.countryCode;
    
    _latitude = location.latitude;
    _longitude = location.longitude;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        if (!aDecoder) {
            return self;
        }
        self.streetNumber = [aDecoder decodeObjectForKey:@"streetNumber"];
        self.streetName = [aDecoder decodeObjectForKey:@"streetName"];
        self.district = [aDecoder decodeObjectForKey:@"district"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.province = [aDecoder decodeObjectForKey:@"province"];
        self.country = [aDecoder decodeObjectForKey:@"country"];
        self.countryCode = [aDecoder decodeObjectForKey:@"countryCode"];
        self.latitude = [aDecoder decodeDoubleForKey:@"latitude"];
        self.longitude = [aDecoder decodeDoubleForKey:@"longitude"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.streetNumber forKey:@"streetNumber"];
    [aCoder encodeObject:self.streetName forKey:@"streetName"];
    [aCoder encodeObject:self.district forKey:@"district"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.province forKey:@"province"];
    [aCoder encodeObject:self.country forKey:@"country"];
    [aCoder encodeObject:self.countryCode forKey:@"countryCode"];
    [aCoder encodeDouble:self.latitude forKey:@"latitude"];
    [aCoder encodeDouble:self.longitude forKey:@"longitude"];
}

@end
