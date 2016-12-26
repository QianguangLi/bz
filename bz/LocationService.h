//
//  LocationService.h
//  bz
//
//  Created by qianchuang on 2016/12/26.
//  Copyright © 2016年 ing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationService : NSObject

+ (instancetype)sharedLocationService;

/**
 开始获取地址信息
 */
- (void)startUserLocationService;

/**
 停止获取地址微信
 */
- (void)stopUserLocationService;

/**
 反向地理编码
 */
- (void)reverseUserLocation;
@end
