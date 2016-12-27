//
//  LocationService.m
//  bz
//
//  Created by qianchuang on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#import "LocationService.h"
#import "BMKLocationService.h"
#import "BMKGeocodeSearch.h"
#import "UserLocationModel.h"

@interface LocationService () <BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>
{
    BMKLocationService *_service;
    CLLocation *_location;
    BMKGeoCodeSearch *_search;
}
@end

static LocationService *sharedLocationService = nil;

@implementation LocationService

+ (instancetype)sharedLocationService
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationService = [[self alloc] init];
        [sharedLocationService startLocationService];
    });
    return sharedLocationService;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationService = [super allocWithZone:zone];
    });
    return sharedLocationService;
}

- (void)startUserLocationService
{
    _service.delegate = self;
    [_service startUserLocationService];
}

- (void)stopUserLocationService
{
    [_service stopUserLocationService];
    _service.delegate = nil;
}

- (void)startLocationService
{
    _service = [[BMKLocationService alloc] init];
}

//反geo地理编码
- (void)reverseUserLocation
{
    if (!_search) {
        _search = [[BMKGeoCodeSearch alloc] init];
    }
    _search.delegate = self;
    //反向地理编码检索
    BMKReverseGeoCodeOption *reverseGeoCodePotion = [[BMKReverseGeoCodeOption alloc] init];
//    NSLog(@"%f,%f", _location.coordinate.latitude, _location.coordinate.longitude);
    reverseGeoCodePotion.reverseGeoPoint = _location.coordinate;
    BOOL flag = [_search reverseGeoCode:reverseGeoCodePotion];
    if (flag) {
        NSLog(@"反geo检索发送成功");
    } else {
        NSLog(@"反geo检索发送失败");
    }
    
}

#pragma mark BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"location success:%@", userLocation.location);
    _location = userLocation.location;
    [self reverseUserLocation];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"获取地理位置信息失败");
}

#pragma mark BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
      if (error == BMK_SEARCH_NO_ERROR) {
          //定位信息反向编码成功后停止获取定位
          [self stopUserLocationService];
          
          NSLog(@"%@", result.address);
          UserLocationModel *model = [[UserLocationModel alloc] init];
          [model setBMKAddressComponent:result.addressDetail];
          //持久化用户地理位置信息
          [Utility persistentUserLocationInformation:model];
          //发送通知：成功获取地址位置信息
          [[NSNotificationCenter defaultCenter] postNotificationName:kLocateUserSuccessNotification object:nil];
      }
      else {
          NSLog(@"抱歉，未找到结果");
      }
}


@end
