//
//  UserLocationModel.h
//  bz
//
//  Created by qianchuang on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMKMapView.h"
@class BMKAddressComponent;
/**
 用户地理位置模型
 */
@interface UserLocationModel : NSObject <NSCoding>
/// 街道号码
@property (nonatomic, strong) NSString* streetNumber;
/// 街道名称
@property (nonatomic, strong) NSString* streetName;
/// 区县名称
@property (nonatomic, strong) NSString* district;
/// 城市名称
@property (nonatomic, strong) NSString* city;
/// 省份名称
@property (nonatomic, strong) NSString* province;
/// 国家
@property (nonatomic, strong) NSString* country;
/// 国家代码
@property (nonatomic, strong) NSString* countryCode;

///地址坐标
@property (assign, nonatomic) CLLocationDegrees latitude;
@property (assign, nonatomic) CLLocationDegrees longitude;

//- (instancetype)initWithBMKAddressComponent:(BMKAddressComponent *)compoent;
- (void)setBMKAddressComponent:(BMKAddressComponent *)compoent andLocation:(CLLocationCoordinate2D)location;

@end
