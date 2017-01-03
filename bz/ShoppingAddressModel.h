//
//  ShoppingAddressModel.h
//  bz
//
//  Created by qianchuang on 2017/1/3.
//  Copyright © 2017年 ing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

/**
 收货地址model
 */
@interface ShoppingAddressModel : JSONModel

@property (copy, nonatomic) NSString *conAddr;//收货街道
@property (copy, nonatomic) NSString *conArea;//收货所在地
@property (copy, nonatomic) NSString<Optional> *conAreacode;//收货地址编码
@property (copy, nonatomic) NSString *conId;//收货地址id
@property (copy, nonatomic) NSString *conMobile;//收货手机号
@property (copy, nonatomic) NSString *conName;//收货人姓名
@property (copy, nonatomic) NSString *conPhone;//收货人电话号码
@property (copy, nonatomic) NSString *conZipCode;//收货地址邮编
@property (copy, nonatomic) NSString *condetail;//收货详细地址
@property (assign, nonatomic) BOOL isDefault;//是否是默认收货地址
@property (copy, nonatomic) NSString<Optional> *latitude;//纬度
@property (copy, nonatomic) NSString<Optional> *longitude;//经度

@end
